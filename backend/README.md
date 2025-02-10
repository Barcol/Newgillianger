# README

## Table of Contents
1.  [Setup](#setup)
2.  [Run](#run)
3.  [API](#api)
    *   [Ceremonies](#ceremonies)
        *   [GET /ceremonies](#get-ceremonies)
        *   [GET /ceremonies/:id](#get-ceremoniesid)
        *   [POST /ceremonies](#post-ceremonies)
        *   [DELETE /ceremonies/:id](#delete-ceremoniesid)

### Setup

```
bundle
rails db:create
```

### Run

```
rails s
```

# API

## Ceremonies

### GET /ceremonies

Returns all ceremonies ids, names and event_dates

#### Optional parameters
```
page (optional): Page number (default 1)
per_page (optional): Elements per page (default 25)
```

#### Example requests

```
/ceremonies
/ceremonies/page/2?per_page=10
```

#### Output example

```json
{
  "ceremonies": [
    {
      "id": 1,
      "name": "Kolokwium",
      "event_date": "2025-03-15T18:00:00Z"
    },
    {
      "id": 2,
      "name": "Ceremonia Otwarcia z Powodu Zamknięcia",
      "event_date": "2025-01-01T12:00:00Z"
    }
  ],
  "meta": 
  {
    "current_page": 1,
    "total_pages": 5,
    "total_count": 50
  }
}
```

### GET /ceremonies/:id

Returns a specific ceremony by id

#### Example request

```
/ceremonies/1
```

#### Output example

```json
{
  "id": 1,
  "name": "Kolokwium",
  "event_date": "2025-03-15T18:00:00Z"
}
```

### POST /ceremonies

Creates a new ceremony

```
curl -X POST http://localhost:3000/ceremonies -H 'Content-Type: application/json' -d '{"ceremony": {"name": "Nowa Ceremonia", "event_date": "2025-03-15T18:00:00Z"}}'
```

#### Parameters

```json
{
  "ceremony":
  {
    "name": "New Ceremony",
    "event_date": "2025-12-31T23:59:59Z"
  }
}
```

#### Example request

```json
POST /ceremonies
Content-Type: application/json {
  "ceremony":
  {
    "name": "New Year's Eve Celebration",
    "event_date": "2025-12-31T23:59:59Z"
  }
}
```

#### Output example (success)

```json
{
  "id": 3,
  "name": "New Year's Eve Celebration",
  "event_date": "2025-12-31T23:59:59Z"
}
```

#### Output example (error)

```json
{
  "errors": ["Name can't be blank", "Event date can't be blank"]
}
```

### DELETE /ceremonies/:id

Deletes a specific ceremony by id

#### Example request

```
DELETE /ceremonies/1
```

#### Output example (success)

```json
{
  "message": "Ceremony successfully deleted"
}
```

#### Output example (error - not found)

```json
{
  "error": "Ceremony not found"
}
```