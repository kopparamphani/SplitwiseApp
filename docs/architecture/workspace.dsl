/*
 * ============================================================
 *  Expense Tracker — C4 model as code (Structurizr DSL)
 * ------------------------------------------------------------
 *  Caveman intro:
 *  This one text file IS our architecture map. We describe the
 *  PEOPLE, the SYSTEMS, and the BOXES inside our system once.
 *  Then we ask for VIEWS (zoom levels) and Structurizr draws them.
 *  Change the text -> the pictures change. No dragging boxes.
 *
 *  Render locally (open-source, no SaaS):
 *    docker run -it --rm -p 8080:8080 -v "$(pwd)":/usr/local/structurizr structurizr/lite
 *    then open http://localhost:8080
 * ============================================================
 */

workspace "Expense Tracker" "Splitwise-parity expense splitter. Release 1." {

    model {

        // ---- People (who uses the system) ----
        user        = person "User" "A person who logs and splits shared expenses."
        placeholder = person "Placeholder Person" "Someone added to a group who has not joined yet. Can hold a balance."

        // ---- External systems (things we use but do not build) ----
        google = softwareSystem "Google Identity" "Used for 'Sign in with Google'." "External"
        email  = softwareSystem "Email Provider"   "Sends sign-up, invite, and password-reset mail." "External"
        push   = softwareSystem "Push Service"      "Sends phone push notices (added during mobile work)." "External"

        // ---- Our system and its containers (the boxes inside) ----
        tracker = softwareSystem "Expense Tracker" "Tracks shared expenses, splits, balances, settle-ups." {

            // -- Front-end apps (clients). Tech labels added in Step 2. --
            web     = container "Web App"     "Full tracker in a browser. Adapts to screen size." "Vite + React + TS" "Web"
            android = container "Android App"  "Native-feel phone app. Built first." "React Native (Expo) + TS" "Mobile"
            ios     = container "iOS App"      "Native-feel phone app. Built after Android." "React Native (Expo) + TS" "Mobile"

            // -- The single front door --
            gateway = container "API Gateway" "One entrance for every client. Routes each request to the right service. Checks the login badge." "NestJS (TS); Kong later" "Edge"

            // -- The 5 worker services, each with its OWN database. All NestJS (TypeScript). --
            identity = container "Identity Service" "Sign up, log in, Google login, password reset, sessions." "NestJS (TS)" "Service"
            identityDb = container "Identity DB" "Stores accounts and hashed credentials. Private to Identity." "PostgreSQL" "Database"

            people = container "People & Groups Service" "Profiles, preferred currency, friends, placeholders, groups, members, invites." "NestJS (TS)" "Service"
            peopleDb = container "People & Groups DB" "Stores users, friendships, groups, memberships, invites. Private to People & Groups." "PostgreSQL" "Database"

            expense = container "Expense Service" "Records expenses: amount, payers, split, category, date, note, recurring, receipt link." "NestJS (TS)" "Service"
            expenseDb = container "Expense DB" "Stores expenses, payers, splits, recurrence rules, audit trail. Private to Expense." "PostgreSQL" "Database"

            balance = container "Balance Service" "The math. Turns expense events into who-owes-whom. Debt-simplify. Settle-ups." "NestJS (TS)" "Service"
            balanceDb = container "Balance DB" "Stores derived balances + settlements (a read model fed by events). Private to Balance." "PostgreSQL" "Database"

            notify = container "Notification Service" "Activity notices, debt reminders, per-user on/off prefs. In-app first; push later." "NestJS (TS)" "Service"
            notifyDb = container "Notification DB" "Stores notices and notification preferences. Private to Notification." "PostgreSQL" "Database"

            // -- Shared infrastructure boxes --
            broker = container "Event Bus" "Carries the 'new expense bell' and other events between services. Async announce-news channel." "Apache Kafka" "Messaging"
            blob   = container "Photo Storage" "Holds receipt photo files. Picture files do not belong in a notebook (database)." "SeaweedFS (S3-compatible)" "Object Store"
        }

        // ============ Relationships ============

        // Clients -> front door
        user -> web     "Uses (browser)"
        user -> android "Uses (Android phone)"
        user -> ios     "Uses (iPhone)"
        web     -> gateway "Makes API calls to" "HTTPS/JSON"
        android -> gateway "Makes API calls to" "HTTPS/JSON"
        ios     -> gateway "Makes API calls to" "HTTPS/JSON"

        // Front door -> services (sync "ask through the window")
        gateway -> identity "Routes auth requests to" "HTTPS/JSON"
        gateway -> people   "Routes user/group requests to" "HTTPS/JSON"
        gateway -> expense  "Routes expense requests to" "HTTPS/JSON"
        gateway -> balance  "Routes balance/settle requests to" "HTTPS/JSON"
        gateway -> notify   "Routes notification requests to" "HTTPS/JSON"

        // Services -> their OWN database (nobody touches another's DB)
        identity -> identityDb "Reads/writes" "private"
        people   -> peopleDb   "Reads/writes" "private"
        expense  -> expenseDb  "Reads/writes" "private"
        balance  -> balanceDb  "Reads/writes" "private"
        notify   -> notifyDb   "Reads/writes" "private"

        // Async events (the "announce news" bell)
        expense -> broker "Publishes expense events (added/edited/deleted)" "async"
        balance -> broker "Publishes settlement events" "async"
        people  -> broker "Publishes group/member events" "async"
        broker  -> balance "Delivers expense + settlement events" "async"
        broker  -> notify  "Delivers events to notify users" "async"

        // Files
        expense -> blob "Stores/fetches receipt photos" "HTTPS"

        // External system use
        identity -> google "Verifies Google sign-in with" "OAuth (HTTPS)"
        identity -> email  "Sends reset/sign-up mail via" "SMTP/API"
        notify   -> email  "Sends email notices via" "SMTP/API"
        notify   -> push   "Sends phone push via" "HTTPS"
    }

    views {

        // ---- C4 Level 1: System Context (the whole-world zoom) ----
        systemContext tracker "SystemContext" "Who uses the Expense Tracker and which outside systems it relies on." {
            include *
            autolayout lr
        }

        // ---- C4 Level 2: Container (the boxes-inside zoom) ----
        container tracker "Containers" "The apps, the gateway, the 5 services + their own databases, and shared infra." {
            include *
            autolayout lr
        }

        /*
         * C4 Level 3 (Component) and the Deployment view are intentionally
         * NOT drawn yet. Component-level detail is added only for services
         * complex enough to need it. The Deployment view waits until we pick
         * the tech (Step 2) and infra/Kubernetes (Step 3) — drawing it now
         * would mean inventing decisions that are still open.
         */

        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Database" {
                shape cylinder
                background #438dd5
                color #ffffff
            }
            element "Messaging" {
                shape pipe
                background #85bbf0
                color #000000
            }
            element "Object Store" {
                shape folder
                background #85bbf0
                color #000000
            }
        }
    }
}
