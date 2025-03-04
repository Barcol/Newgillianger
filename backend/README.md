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
        *   [PUT /ceremonies/:id](#put-ceremoniesid)
        *   [GET /ceremonies/:id/products](#get-ceremoniesidproducts)
    *   [Products](#products)
        *   [GET /products](#get-products)
        *   [POST /products](#post-products)
        *   [PUT /products/:id](#put-productsid)
        *   [DELETE /products/:id](#delete-productsid)
        *   [RESTORE /products/:id](#restore-productsid)
    *   [Users](#users)
        *   [POST /users](#post-users)    

### Setup

```bash
bundle
rails db:create
```

### Run

```bash
rails s
```

# API

## Ceremonies

### GET /ceremonies

Returns all ceremonies ids, names and event_dates

#### Optional parameters
```bash
page (optional): Page number (default 1)
per_page (optional): Elements per page (default 25)
```

#### Example requests

```bash
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

```bash
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

```bash
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

```bash
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

### PUT /ceremonies/:id

Edits a specific ceremony by its id

#### Example request

```json
Content-Type: application/json
{
  "ceremony": {
    "name": "Updated Ceremony Name",
    "event_date": "2025-12-31"
  }
}
```

#### Output example (success)

```json
{
  "id": 1,
  "name": "Updated Ceremony Name",
  "event_date": "2025-12-31"
}
```

#### Output example (error - not found)

```json
{
  "errors": [
    "Name can't be blank",
    "Event date is invalid"
  ]
}
```
```json
{
  "error": "Ceremony not found"
}
```

### GET /ceremonies/:id/products

```sh
curl -X GET http://localhost:3000/ceremonies/CEREMONY_ID/products -H "Accept: application/json"
curl -X GET "http://localhost:3000/ceremonies/CEREMONY_ID/products?page=1&per_page=20" -H "Accept: application/json"
```

## Products

### GET /products
Lists all ceremonies products (I believe, in the future, this endpoint will be available only for admins (nice to have during development))

```shell
/products
```

```bash
curl -X GET http://localhost:3000/products -H "Accept: application/json"
curl -X GET "http://localhost:3000/products/page/1?per_page=20" -H "Accept: application/json"
```

### POST /products

Creates a new product

```bash
curl -X POST http://localhost:3000/products \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -d '{"product": {"title": "Nowy produkt", "price": "99.99", "currency": "PLN"}, "ceremony_id": "CEREMONY_UUID"}'
```
#### Parameters

```json
{
  "product": 
  {
    "title": "Nowy produkt", 
    "price": "99.99", 
    "currency": "PLN"
  }, 
  "ceremony_id": "4c447a05-4632-41ea-a430-9474cbba49c4"
}
```

### PUT /products/:id

Edits a specific product by its id

#### Example request

```json
Content-Type: application/json
{
  "product": {
    "title": "Worki zmienne",
    "price": "99.99", 
    "currency": "PLN"
  }
}
```
```shell
curl -X PUT http://localhost:3000/products/PRODUCT_ID \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -d '{"product": {"title": "Worki zmienne", "price": "99.99", "currency": "PLN"}}'
```

### DELETE /products/:id

Deletes a specific product by id

#### Example request

```bash
DELETE /products/1
```

#### Output example (success)

```json
{
  "message": "Product successfully deleted"
}
```

#### Output example (error - not found)

```json
{
  "error": "Product not found"
}
```

### RESTORE /products/:id

Restores a specific soft-deleted product by id

#### Example request

```bash
PUT /products/1
```

#### Output example (success)

```json
{
  "message": "Product successfully restored"
}
```

#### Output example (error - not found)

```json
{
  "error": "Product not found"
}
```

## Users
### POST /users
Creates user

``` bash
  curl -X POST localhost:3000/users -H 'Content-Type: application/json' -d '{"user": {"email": "newuser@example.com", "password": "securepassword123"}}'
```

#### Output example (success)

```json
{
  "message": "User successfully created"
}
```

#### Output example (error - validation error)

```json
{
  "message": "errors: {'password': ['cant be blank']}"
}
```

#### Output example (error - email taken)

```json
{
  "error":"Email address is already in use"
}
```

