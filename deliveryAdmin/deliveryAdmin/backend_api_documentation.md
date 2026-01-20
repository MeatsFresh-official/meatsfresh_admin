<!-- # Backend API Specification for Zenith Admin Panel

**Target Audience:** Backend Developers
**Purpose:** This document defines the required API Endpoints, Request Parameters, and JSON Response structures needed to power the Zenith Admin Panel UI. The UI expects these exact field names and structures.

---

## 1. Orders & Billings Module
**UI Page:** `orders-billings.jsp`
**JS Reference:** `orders-billings.js`

### 1.1 Fetch Orders List
Returns a paginated, filtered list of orders.

*   **Endpoint:** `GET /api/orders`
*   **Query Parameters (Filters):**
    *   `page` (int): Page number (default 0).
    *   `size` (int): Page size (default 10).
    *   `status` (enum/string): Filter by order status.
        *   *UI Values:* `ALL`, `PENDING_VENDOR_APPROVAL`, `PLACED`, `ACCEPTED_BY_VENDOR`, `ORDER_PREPARING`, `ORDER_READY`, `DELIVERY_PARTNER_ASSIGNED`, `ORDER_PICKED`, `ON_THE_WAY`, `DELIVERED`, `CANCELLED`.
    *   `dateRange` (string): Pre-defined range (`today`, `week`, `month`, `year`) OR specific dates via `startDate` / `endDate`.
    *   `search` (string): Search text for Order ID, Customer Name, or Shop Name.

*   **Expected JSON Response:**
    ```json
    {
      "content": [
        {
          "id": 1001,
          "orderCode": "ORD-20241001",
          "customer": "John Doe",
          "shop": "Meat Masters",
          "itemCount": "3 Items",
          "total": "450.00",
          "status": "DELIVERED",
          "date": "2023-10-25 14:30:00",
          "deliveryBoy": "Raju Rider", // Or "Unassigned"
          "phone": "+91 9876543210",
          "address": "123 MG Road, Bengaluru",
          "subtotal": "400.00",
          "deliveryFee": "30.00",
          "tax": "20.00",
          "itemsList": [
            {
              "name": "Chicken Curry",
              "qty": 2,
              "price": 150.00
            },
            {
              "name": "Naan",
              "qty": 4,
              "price": 25.00
            }
          ]
        }
      ],
      "totalElements": 150,
      "totalPages": 15
    }
    ```

### 1.2 Update Order Status
Updates the lifecycle status of an order.

*   **Endpoint:** `PUT /api/orders/{id}/status`
*   **Request Body:**
    ```json
    {
      "status": "ACCEPTED_BY_VENDOR" // See list in 1.1
    }
    ```
*   **Expected Response:** `{ "success": true, "message": "Status updated" }`

---

## 2. Profit & Revenue Module
**UI Page:** `profit.jsp`
**JS Reference:** `profit.js`

### 2.1 Fetch Financial Statistics
Returns financial totals and breakdown for a specific date range.

*   **Endpoint:** `POST /api/finance/stats`
*   **Request Body:**
    ```json
    {
      "startDate": "2023-10-01",
      "endDate": "2023-10-31"
    }
    ```
*   **Expected JSON Response (Exact Keys Required):**
    ```json
    {
      "totalOrder": 500000.00,       // Total Revenue (Gross)
      "commission": 75000.00,        // Platform Commission
      "payVendor": 350000.00,        // Amount payable to vendors
      "profit": 15000.00,            // Net Profit
      "platformFee": 5000.00,        // Platform fee collected from users
      "serviceFee": 2000.00,
      "deliveryUser": 8000.00,       // Delivery fees paid by users
      "deliveryPartner": 6000.00,    // Amount paid to riders
      "gst": 25000.00,
      "rainFee": 500.00,
      "packagingFee": 1000.00
    }
    ```

### 2.2 Fetch Revenue Trend Chart
Data for the "Revenue vs Profit" linear chart.

*   **Endpoint:** `POST /api/finance/chart/revenue`
*   **Request Body:** (Same as 2.1)
*   **Expected JSON Response:**
    ```json
    {
      "labels": ["Oct 1", "Oct 2", "Oct 3"...],
      "revenueData": [10000, 12000, 15000...],
      "profitData": [2000, 2400, 3000...]
    }
    ```

---

## 3. User Detail View Module
**UI Page:** `user-view.jsp`
**JS Reference:** `user-view.js`

### 3.1 Fetch User Profile
Returns basic user info and stats.

*   **Endpoint:** `GET /api/users/{userId}`
*   **Expected JSON Response:**
    ```json
    {
      "id": 101,
      "name": "Abhishek Sharma",
      "email": "abhishek.sharma@example.com",
      "phone": "+91 98765 43210",
      "dob": "1995-08-15",
      "profileImage": "http://img.url/...",
      "stats": {
          "orders": 24,
          "spent": 15400,
          "wallet": 250,
          "activeDays": 5
      },
      "preferences": {
          "sms": true,
          "whatsapp": true,
          "email": false,
          "promo": true
      }
    }
    ```

### 3.2 Fetch User Addresses
*   **Endpoint:** `GET /api/users/{userId}/addresses`
*   **Expected JSON Response:**
    ```json
    [
      {
        "id": 101,
        "type": "HOME", // HOME, WORK, OTHERS
        "houseNo": "Flat 402",
        "address": "Blue Ridge Apartments",
        "landmark": "Opposite Wipro",
        "lat": 18.5913,
        "lng": 73.7389,
        // Optional receiver details for OTHERS
        "receiverName": "Friend Name",
        "receiverPhone": "+91 9999999999"
      }
    ]
    ```

### 3.3 Fetch User Orders History
*   **Endpoint:** `GET /api/users/{userId}/orders`
*   **Expected JSON Response:**
    ```json
    [
      {
        "id": "ORD-9921",
        "date": "18 Jan 2026",
        "items": "Chicken Curry Cut (500g)",
        "status": "DELIVERED",
        "amount": "₹450"
      }
    ]
    ```

### 3.4 Get Full Order Details
Used for the "View Details" modal popup.

*   **Endpoint:** `GET /api/orders/{orderId}/details`
*   **Expected JSON Response:**
    ```json
    {
       "id": "ORD-9921",
       "date": "18 Jan 2026, 02:30 PM",
       "status": "DELIVERED",
       "vendor": {
          "name": "Fresh Meat House",
          "address": "Sector 18, Noida",
          "phone": "+91 9988776655"
       },
       "partner": {
          "name": "Ramesh Kumar",
          "phone": "+91 8877665544",
          "vehicle": "Bike (UP-16-AB-1234)"
       },
       "items": [
          { "name": "Chicken Curry Cut", "price": 225, "qty": 2, "total": 450 }
       ],
       "bill": {
          "subtotal": 500,
          "deliveryFee": 40,
          "tax": 25,
          "discount": 50,
          "total": 515
       }
    }
    ```

---

## 4. Ratings & Reviews Module
**UI Page:** `users-reviewAndratings.jsp`
**JS Reference:** `users-reviewAndratings.js`

### 4.1 Fetch Reviews Dashboard Data
Populates the main table and performance cards.

*   **Endpoint:** `POST /api/reviews/dashboard`
*   **Request Body (Filters):**
    ```json
    {
      "reviewType": "ALL",    // Options: "ALL", "VENDOR", "DELIVERY"
      "rating": 5,            // Options: null (All), 1-5
      "status": "PENDING"     // Options: "ALL", "APPROVED", "PENDING", "REJECTED"
    }
    ```
*   **Expected JSON Response:**
    ```json
    {
      "customerReviews": [
        {
          "id": "REV-123",
          "reviewerName": "Alice Smith",
          "reviewerImage": "url_to_image.jpg", // Optional
          "type": "VENDOR",
          "rating": 5,
          "comment": "Great food!",
          "date": "2023-10-27T10:00:00",
          "status": "APPROVED",
          "images": ["img1.jpg", "img2.jpg"]
        }
      ],
      "vendorPerformance": [
        {
          "id": "VEN-001",
          "vendorName": "KFC",
          "rating": 4.5,
          "totalReviews": 100,
          "fiveStar": 60,
          "fourStar": 20,
          "threeStar": 10,
          "twoStar": 5,
          "oneStar": 5
        }
      ],
      "deliveryPerformance": [
         // Same structure as Vendor Performance but for Riders
      ]
    }
    ```

### 4.2 Moderate Review
Approve or Reject a review.

*   **Endpoint:** `PUT /reviews/{id}/status`
*   **Request Body:** `{ "status": "APPROVED" }`

### 4.3 Reply to Review
*   **Endpoint:** `POST /reviews/{id}/reply`
*   **Request Body:**
    ```json
    {
      "reply": "Thank you for your feedback!",
      "sendEmail": true
    }
    ```

---

## 5. Delivery Boy Orders (Logistics)
**UI Page:** `deliveryBoy-orders.jsp`
**JS Reference:** `deliveryBoy-orders.js`

### 5.1 Fetch Assigned Orders
*   **Endpoint:** `GET /api/delivery/orders`
*   **Query Parameters:**
    *   `filter`: `all` | `pending` | `completed`
*   **Expected JSON Response:**
    ```json
    [
      {
        "orderId": "ORD-555",
        "customerName": "Rahul Dravid",
        "totalAmount": 550.00,
        "deliveryAddress": "Indiranagar, Bangalore",
        "status": "CONFIRMED",
        "riderName": null, // Null if unassigned
        "orderTime": "2023-10-28T09:30:00",
        "financials": {
           "baseFee": 25.00,
           "surgeFee": 10.00,
           "tip": 0.00,
           "incentive": 15.00
        }
      }
    ]
    ```

### 5.2 Assign Rider Manually
*   **Endpoint:** `POST /api/delivery/orders/{orderId}/assign`
*   **Request Body:** `{ "riderId": 123 }`

---

## 6. Delivery Incentives
**UI Page:** `deliveryBoy-incentives.jsp`

### 6.1 Create Incentive Program
*   **Endpoint:** `POST /api/incentives/create`
*   **Request Body:**
    ```json
    {
      "ordersTarget": 50,
      "slotsTarget": 5,
      "rewardAmount": 1500.00
    }
    ```

### 6.2 Get Active Incentives
*   **Endpoint:** `GET /api/incentives/active`
*   **Expected Response:** List of active incentive objects. -->
