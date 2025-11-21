# Consumption Logs API Documentation

This document defines the API endpoints required for the Consumption Logs feature.

## Overview

The Consumption Logs feature allows users to track what food items they have consumed, helping them monitor their eating patterns and manage inventory more effectively.

---

## Data Model

### ConsumptionLog Entity

```json
{
  "id": "string",
  "itemName": "string",
  "quantity": "number (double)",
  "unit": "string",
  "category": "string (enum: dairy, fruit, grain)",
  "date": "string (ISO 8601 date-time)",
  "notes": "string (optional)",
  "userId": "string",
  "createdAt": "string (ISO 8601 date-time)",
  "updatedAt": "string (ISO 8601 date-time)"
}
```

### Category Enum
- `dairy` - Dairy products (milk, cheese, yogurt, etc.)
- `fruit` - Fruits and fruit products
- `grain` - Grains and grain products (bread, pasta, rice, etc.)

---

## API Endpoints

### 1. Get All Consumption Logs

Retrieve all consumption logs for the authenticated user.

**Endpoint:** `GET /api/consumption-logs`

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `page` | integer | No | Page number (default: 1) |
| `limit` | integer | No | Items per page (default: 20) |
| `category` | string | No | Filter by category (dairy, fruit, grain) |
| `startDate` | string | No | Filter logs from this date (ISO 8601) |
| `endDate` | string | No | Filter logs up to this date (ISO 8601) |
| `sortBy` | string | No | Sort field (date, itemName, quantity) |
| `sortOrder` | string | No | Sort order (asc, desc) |

**Success Response:**

**Code:** `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "id": "log-001",
      "itemName": "Oat Milk",
      "quantity": 0.5,
      "unit": "L",
      "category": "dairy",
      "date": "2025-11-21T08:30:00Z",
      "notes": "Used in breakfast cereal.",
      "userId": "user-123",
      "createdAt": "2025-11-21T08:30:00Z",
      "updatedAt": "2025-11-21T08:30:00Z"
    },
    {
      "id": "log-002",
      "itemName": "Blueberries",
      "quantity": 150,
      "unit": "g",
      "category": "fruit",
      "date": "2025-11-20T12:00:00Z",
      "notes": "Smoothie batch for 2 servings.",
      "userId": "user-123",
      "createdAt": "2025-11-20T12:00:00Z",
      "updatedAt": "2025-11-20T12:00:00Z"
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalItems": 87,
    "itemsPerPage": 20
  }
}
```

**Error Response:**

**Code:** `401 Unauthorized`
```json
{
  "success": false,
  "error": "Authentication required"
}
```

---

### 2. Get Consumption Log by ID

Retrieve a specific consumption log.

**Endpoint:** `GET /api/consumption-logs/{id}`

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**URL Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Consumption log ID |

**Success Response:**

**Code:** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "log-001",
    "itemName": "Oat Milk",
    "quantity": 0.5,
    "unit": "L",
    "category": "dairy",
    "date": "2025-11-21T08:30:00Z",
    "notes": "Used in breakfast cereal.",
    "userId": "user-123",
    "createdAt": "2025-11-21T08:30:00Z",
    "updatedAt": "2025-11-21T08:30:00Z"
  }
}
```

**Error Responses:**

**Code:** `404 Not Found`
```json
{
  "success": false,
  "error": "Consumption log not found"
}
```

**Code:** `403 Forbidden`
```json
{
  "success": false,
  "error": "Not authorized to access this resource"
}
```

---

### 3. Create Consumption Log

Add a new consumption log entry.

**Endpoint:** `POST /api/consumption-logs`

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "itemName": "Oat Milk",
  "quantity": 0.5,
  "unit": "L",
  "category": "dairy",
  "date": "2025-11-21T08:30:00Z",
  "notes": "Used in breakfast cereal."
}
```

**Request Body Schema:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `itemName` | string | Yes | Name of the consumed item |
| `quantity` | number | Yes | Amount consumed |
| `unit` | string | Yes | Unit of measurement (L, g, kg, ml, etc.) |
| `category` | string | Yes | Category enum (dairy, fruit, grain) |
| `date` | string | Yes | Date and time of consumption (ISO 8601) |
| `notes` | string | No | Additional notes about the consumption |

**Success Response:**

**Code:** `201 Created`

```json
{
  "success": true,
  "message": "Consumption log created successfully",
  "data": {
    "id": "log-001",
    "itemName": "Oat Milk",
    "quantity": 0.5,
    "unit": "L",
    "category": "dairy",
    "date": "2025-11-21T08:30:00Z",
    "notes": "Used in breakfast cereal.",
    "userId": "user-123",
    "createdAt": "2025-11-21T08:30:00Z",
    "updatedAt": "2025-11-21T08:30:00Z"
  }
}
```

**Error Responses:**

**Code:** `400 Bad Request`
```json
{
  "success": false,
  "error": "Validation failed",
  "details": {
    "itemName": "Item name is required",
    "quantity": "Quantity must be greater than 0"
  }
}
```

**Code:** `401 Unauthorized`
```json
{
  "success": false,
  "error": "Authentication required"
}
```

---

### 4. Update Consumption Log

Update an existing consumption log.

**Endpoint:** `PUT /api/consumption-logs/{id}`

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**URL Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Consumption log ID |

**Request Body:**
```json
{
  "itemName": "Oat Milk",
  "quantity": 1.0,
  "unit": "L",
  "category": "dairy",
  "date": "2025-11-21T08:30:00Z",
  "notes": "Used in breakfast cereal and coffee."
}
```

**Request Body Schema:**
All fields are optional. Only include fields you want to update.

| Field | Type | Description |
|-------|------|-------------|
| `itemName` | string | Name of the consumed item |
| `quantity` | number | Amount consumed |
| `unit` | string | Unit of measurement |
| `category` | string | Category enum (dairy, fruit, grain) |
| `date` | string | Date and time of consumption (ISO 8601) |
| `notes` | string | Additional notes |

**Success Response:**

**Code:** `200 OK`

```json
{
  "success": true,
  "message": "Consumption log updated successfully",
  "data": {
    "id": "log-001",
    "itemName": "Oat Milk",
    "quantity": 1.0,
    "unit": "L",
    "category": "dairy",
    "date": "2025-11-21T08:30:00Z",
    "notes": "Used in breakfast cereal and coffee.",
    "userId": "user-123",
    "createdAt": "2025-11-21T08:30:00Z",
    "updatedAt": "2025-11-21T09:15:00Z"
  }
}
```

**Error Responses:**

**Code:** `404 Not Found`
```json
{
  "success": false,
  "error": "Consumption log not found"
}
```

**Code:** `403 Forbidden`
```json
{
  "success": false,
  "error": "Not authorized to update this resource"
}
```

**Code:** `400 Bad Request`
```json
{
  "success": false,
  "error": "Validation failed",
  "details": {
    "quantity": "Quantity must be greater than 0"
  }
}
```

---

### 5. Delete Consumption Log

Delete a consumption log entry.

**Endpoint:** `DELETE /api/consumption-logs/{id}`

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**URL Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | Consumption log ID |

**Success Response:**

**Code:** `200 OK`

```json
{
  "success": true,
  "message": "Consumption log deleted successfully"
}
```

**Error Responses:**

**Code:** `404 Not Found`
```json
{
  "success": false,
  "error": "Consumption log not found"
}
```

**Code:** `403 Forbidden`
```json
{
  "success": false,
  "error": "Not authorized to delete this resource"
}
```

---

### 6. Get Consumption Statistics

Get aggregated consumption statistics for the user.

**Endpoint:** `GET /api/consumption-logs/statistics`

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `period` | string | No | Time period (week, month, year) - default: month |
| `startDate` | string | No | Custom start date (ISO 8601) |
| `endDate` | string | No | Custom end date (ISO 8601) |

**Success Response:**

**Code:** `200 OK`

```json
{
  "success": true,
  "data": {
    "period": "month",
    "totalLogs": 87,
    "byCategory": {
      "dairy": {
        "count": 32,
        "percentage": 36.8
      },
      "fruit": {
        "count": 28,
        "percentage": 32.2
      },
      "grain": {
        "count": 27,
        "percentage": 31.0
      }
    },
    "topItems": [
      {
        "itemName": "Oat Milk",
        "count": 15,
        "totalQuantity": 7.5,
        "unit": "L"
      },
      {
        "itemName": "Blueberries",
        "count": 12,
        "totalQuantity": 1800,
        "unit": "g"
      }
    ],
    "averageLogsPerDay": 2.9
  }
}
```

---

## Implementation Notes

### Frontend Implementation Requirements

1. **Data Layer**
   - Create `ConsumptionLogModel` extending `ConsumptionLog` entity
   - Implement `ConsumptionLogRemoteDataSource` for API calls
   - Implement `ConsumptionLogRepository` for data management

2. **Domain Layer**
   - Define use cases:
     - `GetAllConsumptionLogs`
     - `GetConsumptionLogById`
     - `CreateConsumptionLog`
     - `UpdateConsumptionLog`
     - `DeleteConsumptionLog`
     - `GetConsumptionStatistics`

3. **Presentation Layer**
   - Create `ConsumptionLogBloc` for state management
   - Define events and states
   - Update existing pages to use BLoC

4. **API Integration**
   - All endpoints require authentication (Bearer token)
   - Use HTTP interceptor for automatic token injection
   - Handle error responses appropriately
   - Implement pagination for list views

### Validation Rules

**Client-side:**
- `itemName`: Required, max 100 characters
- `quantity`: Required, must be > 0
- `unit`: Required, max 20 characters
- `category`: Required, must be one of: dairy, fruit, grain
- `date`: Required, must be valid ISO 8601 date, cannot be in future
- `notes`: Optional, max 500 characters

**Server-side should enforce the same rules**

### Error Handling

- Network errors: Show retry option
- Validation errors: Display field-specific messages
- 404 errors: Navigate back or show not found message
- 403 errors: Check authentication, potentially redirect to login
- 500 errors: Show generic error message with support contact

### Pagination

- Default page size: 20 items
- Implement infinite scroll or "Load More" button
- Cache loaded pages for better UX

### Offline Support (Future Enhancement)

- Store logs locally using local database
- Sync when connection is restored
- Show sync status indicator

---

## Testing Endpoints

### Example cURL Commands

**Create Log:**
```bash
curl -X POST https://ecobite-backend.onrender.com/api/consumption-logs \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "itemName": "Oat Milk",
    "quantity": 0.5,
    "unit": "L",
    "category": "dairy",
    "date": "2025-11-21T08:30:00Z",
    "notes": "Used in breakfast cereal."
  }'
```

**Get All Logs:**
```bash
curl -X GET "https://ecobite-backend.onrender.com/api/consumption-logs?page=1&limit=20" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Update Log:**
```bash
curl -X PUT https://ecobite-backend.onrender.com/api/consumption-logs/log-001 \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "quantity": 1.0,
    "notes": "Used in breakfast cereal and coffee."
  }'
```

**Delete Log:**
```bash
curl -X DELETE https://ecobite-backend.onrender.com/api/consumption-logs/log-001 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## API Endpoints Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/consumption-logs` | Get all consumption logs | Yes |
| GET | `/api/consumption-logs/{id}` | Get consumption log by ID | Yes |
| POST | `/api/consumption-logs` | Create new consumption log | Yes |
| PUT | `/api/consumption-logs/{id}` | Update consumption log | Yes |
| DELETE | `/api/consumption-logs/{id}` | Delete consumption log | Yes |
| GET | `/api/consumption-logs/statistics` | Get consumption statistics | Yes |

---

## Next Steps

1. ✅ Review and approve API specification
2. ⏳ Backend team implements endpoints
3. ⏳ Frontend team implements data layer
4. ⏳ Frontend team implements domain layer
5. ⏳ Frontend team updates presentation layer
6. ⏳ Integration testing
7. ⏳ User acceptance testing
