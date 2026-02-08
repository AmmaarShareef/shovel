# Mock Backend Test Guide

This app uses a **complete mock backend** for testing. No real API calls are made.

## Test Accounts

All test accounts use the same password: **`test123`**

### Customer Accounts
1. **John Doe** (Primary Customer)
   - Email: `customer@test.com`
   - Phone: +1-555-0101
   - Active jobs

2. **Jane Smith** (Secondary Customer)
   - Email: `jane@test.com`
   - Phone: +1-555-0102
   - Can post jobs

### Shoveler Accounts
1. **Mike Shoveler** (Experienced - 4.8 rating)
   - Email: `mike@scoop.com`
   - Phone: +1-555-0201
   - Total jobs: 127
   - On-time reliability: 94.5%
   - Service area: Lower Manhattan

2. **Sarah Snow** (Top-rated - 4.9 rating)
   - Email: `sarah@scoop.com`
   - Phone: +1-555-0202
   - Total jobs: 89
   - On-time reliability: 97.2%
   - Service area: East Village/Brooklyn

3. **Tom Plow** (New - 4.6 rating)
   - Email: `tom@scoop.com`
   - Phone: +1-555-0203
   - Total jobs: 34
   - On-time reliability: 91.8%
   - Service area: Midtown/Upper Manhattan

---

## Available Jobs (Mock Data)

### Pending Jobs (Green status - awaiting acceptance)

**Job 1: Clear driveway and sidewalk**
- Customer: John Doe
- Location: 123 Main St, Manhattan
- Payment: $50
- Status: Pending
- Action: Shovelers can accept this job

**Job 2: Parking lot snow removal**
- Customer: Jane Smith
- Location: 456 Oak Avenue, Brooklyn
- Payment: $85
- Status: Pending
- Action: Shovelers can accept this job

### Accepted Jobs (Blue status - shoveler is coming)

**Job 3: Front yard snow removal**
- Customer: John Doe
- Shoveler: Mike Shoveler
- Location: 789 Pine Street, Manhattan
- Payment: $45
- Status: Accepted (in progress)
- Deadline: Within 4 hours

### Being Verified (Yellow status - awaiting AI decision)

**Job 4: Driveway and steps**
- Customer: John Doe
- Shoveler: Sarah Snow
- Status: Completed, awaiting AI verification
- Watch this job to see verification system

### Completed/Verified (Green status - payment released)

**Job 5: Clear parking lot**
- Customer: Jane Smith
- Shoveler: Mike Shoveler
- Status: Verified & Paid
- Payment: $75 (released)
- AI Confidence: 96.5%

**Job 6: Residential driveway**
- Customer: John Doe
- Shoveler: Tom Plow
- Status: Verified & Paid
- Payment: $55 (released)
- AI Confidence: 94.2%

---

## Features to Test

### 1. Authentication
- ✅ Login with customer account (customer@test.com / test123)
- ✅ Login with shoveler account (mike@scoop.com / test123)
- ✅ Register new account
- ✅ Logout

### 2. Customer Features
- ✅ View jobs they've posted
- ✅ Post a new job
- ✅ View job details
- ✅ Track job status in real-time
- ✅ Rate completed jobs
- ✅ View available shovelers

### 3. Shoveler Features
- ✅ View available jobs
- ✅ Accept a job
- ✅ Mark job as complete
- ✅ Upload after photos
- ✅ View job history
- ✅ See earnings

### 4. Job States (Full Lifecycle)
- Pending → Accepted → Completed → Verified → Paid
- See all states in the mock data

### 5. AI Verification System
- Job 4 is "Completed" but not yet verified
- Watch the AI verification simulate (confidence score + details)

### 6. Ratings & Reviews
- View shoveler ratings (4.6 - 4.9 stars)
- Submit ratings after job completion
- Track job history

---

## Mock Data Behavior

### Realistic Delays
- Login/Register: 1 second delay
- Job operations: 0.5-1.5 second delays
- API calls: Instant to 1 second

### Auto-Transitions
- Completing a job triggers auto-verification after 2 seconds
- All verification results are positive (for testing)

### Data Persistence
- Mock data resets on app restart
- All created jobs/ratings persist during session
- New users added to mock database

---

## API Endpoints Mocked

### Authentication
- `POST /auth/login` → Customer or Shoveler login
- `POST /auth/register` → Create new account
- `POST /auth/logout` → Logout
- `POST /auth/refresh` → Refresh token

### Jobs
- `GET /jobs` → List all jobs
- `GET /jobs/{id}` → Get job details
- `POST /jobs` → Create new job (customers)
- `POST /jobs/{id}/accept` → Accept job (shovelers)
- `POST /jobs/{id}/complete` → Mark job complete (shovelers)
- `GET /jobs/{id}/status` → Get current job status
- `POST /jobs/{id}/rating` → Submit rating/review

### Users
- `GET /users/profile` → Get current user profile
- `GET /users/{id}` → Get any user's profile
- `PUT /users/profile` → Update profile
- `POST /users/boundary` → Set shoveler service area

### Photos
- `POST /photos/upload` → Upload before/after photos
- `GET /photos/{id}` → Retrieve photo URL

---

## How to Test Different Flows

### Flow 1: Customer Posting a Job
1. Login as: `customer@test.com` / `test123`
2. Click "Post New Job"
3. Fill in details (title, description, location, deadline, payment)
4. Upload a before photo
5. Submit
6. Watch job appear in "Pending" status

### Flow 2: Shoveler Accepting a Job
1. Login as: `mike@scoop.com` / `test123`
2. View available jobs
3. Click on pending job
4. Click "Accept Job"
5. Status changes to "Accepted"
6. Payment moves to "Escrowed"

### Flow 3: Completing & Verification
1. Log in as shoveler
2. Accept any pending job
3. Click "Mark Complete"
4. Upload after photo
5. Job status → "Completed"
6. Wait 2 seconds
7. Job automatically → "Verified" with AI confidence score

### Flow 4: Rating a Shoveler
1. Login as customer
2. Go to completed jobs
3. Click "Rate Shoveler"
4. Select rating (1-5 stars)
5. Add optional comment
6. Submit rating

---

## Testing Tips

### To see different job states:
- Use different filter options to view:
  - Pending jobs
  - Accepted jobs  
  - Completed jobs
  - Verified/paid jobs

### To test role-based features:
- Login as customer to post jobs
- Login as shoveler to accept/complete jobs
- Switch roles to see different UI

### To check shoveler profiles:
- View "Available Shovelers" list
- See ratings, total jobs completed, service area
- Sort by distance/rating

### To test real-time updates:
- Accept a job and watch status change
- Complete a job and watch AI verification happen
- Refresh page to see persisted state

---

## Notes

- **No actual payments** are processed (all mock)
- **No real GPS/location** tracking (hardcoded NYC coordinates)
- **All photos** are placeholder images
- **AI verification** always returns positive results for testing
- **Data is not persistent** across app restarts

To switch to real API later:
1. Change `useMockServices = false` in `lib/utils/config.dart`
2. Update `apiBaseUrl` with real backend URL
3. Switch to RealAuthService, RealJobsService, etc.

---

*Last Updated: February 7, 2026*
