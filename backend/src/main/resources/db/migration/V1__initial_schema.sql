CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_roles (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

CREATE TABLE role_permissions (
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID REFERENCES categories(id),
    name VARCHAR(150) NOT NULL,
    description VARCHAR(500),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_category_parent_name UNIQUE (parent_id, name)
);

CREATE TABLE brands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL UNIQUE,
    description VARCHAR(500),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    symbol VARCHAR(30) NOT NULL UNIQUE,
    conversion_factor NUMERIC(19,6) NOT NULL DEFAULT 1,
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sku VARCHAR(100) NOT NULL UNIQUE,
    barcode VARCHAR(100) UNIQUE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category_id UUID REFERENCES categories(id),
    brand_id UUID REFERENCES brands(id),
    unit_id UUID REFERENCES units(id),
    cost_price NUMERIC(19,4) NOT NULL DEFAULT 0,
    selling_price NUMERIC(19,4) NOT NULL DEFAULT 0,
    minimum_selling_price NUMERIC(19,4),
    tax_rate NUMERIC(8,4) NOT NULL DEFAULT 0,
    reorder_level NUMERIC(19,4) NOT NULL DEFAULT 0,
    reorder_quantity NUMERIC(19,4) NOT NULL DEFAULT 0,
    weight NUMERIC(19,6),
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE warehouses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL UNIQUE,
    address VARCHAR(500),
    contact_name VARCHAR(150),
    contact_phone VARCHAR(50),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id),
    warehouse_id UUID NOT NULL REFERENCES warehouses(id),
    on_hand_quantity NUMERIC(19,4) NOT NULL DEFAULT 0,
    reserved_quantity NUMERIC(19,4) NOT NULL DEFAULT 0,
    average_cost NUMERIC(19,4) NOT NULL DEFAULT 0,
    version BIGINT NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_inventory_product_warehouse UNIQUE (product_id, warehouse_id),
    CONSTRAINT ck_inventory_nonnegative_reserved CHECK (reserved_quantity >= 0)
);

CREATE TABLE stock_movements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id),
    warehouse_id UUID NOT NULL REFERENCES warehouses(id),
    movement_type VARCHAR(40) NOT NULL,
    quantity NUMERIC(19,4) NOT NULL,
    previous_quantity NUMERIC(19,4) NOT NULL,
    new_quantity NUMERIC(19,4) NOT NULL,
    unit_cost NUMERIC(19,4),
    reference_type VARCHAR(50),
    reference_id UUID,
    reason VARCHAR(500),
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_inventory_warehouse ON inventory(warehouse_id);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_stock_movements_product_date ON stock_movements(product_id, created_at DESC);
CREATE INDEX idx_stock_movements_warehouse_date ON stock_movements(warehouse_id, created_at DESC);
CREATE INDEX idx_stock_movements_reference ON stock_movements(reference_type, reference_id);

INSERT INTO roles(name, description) VALUES
 ('SUPER_ADMIN', 'Full system access'),
 ('ADMIN', 'Administrative and management access'),
 ('INVENTORY_MANAGER', 'Inventory and warehouse operations'),
 ('SALES_USER', 'Sales operations'),
 ('PURCHASE_USER', 'Purchase operations'),
 ('VIEWER', 'Read-only access');

INSERT INTO permissions(name, description) VALUES
 ('PRODUCT_READ', 'View products'),
 ('PRODUCT_WRITE', 'Create and update products'),
 ('INVENTORY_READ', 'View inventory'),
 ('INVENTORY_WRITE', 'Perform inventory operations'),
 ('PURCHASE_WRITE', 'Create and receive purchases'),
 ('SALES_WRITE', 'Create and complete sales'),
 ('REPORT_READ', 'View reports'),
 ('ADMIN_WRITE', 'Manage users and system settings');

INSERT INTO units(name, symbol) VALUES
 ('Piece', 'pcs'), ('Kilogram', 'kg'), ('Liter', 'L'), ('Box', 'box');
