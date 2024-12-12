import 'package:vania/vania.dart';
import 'package:vaniabackend/app/http/controllers/auth_controller.dart';
import 'package:vaniabackend/app/http/controllers/todo_controller.dart';
import 'package:vaniabackend/app/http/controllers/user_controller.dart';
import 'package:vaniabackend/app/http/middleware/authenticate.dart';
import 'package:vaniabackend/app/http/controllers/customers_controller.dart';
import 'package:vaniabackend/app/http/controllers/orderitems_controller.dart';
import 'package:vaniabackend/app/http/controllers/orders_controller.dart';
import 'package:vaniabackend/app/http/controllers/productnotes_controller.dart';
import 'package:vaniabackend/app/http/controllers/products_controller.dart';
import 'package:vaniabackend/app/http/controllers/vendors_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    // Base RoutePrefix
    Router.basePrefix('api');
    Router.group(() {
      Router.post('register', authController.register);
      Router.post('login', authController.login);
    }, prefix: 'auth');

    Router.get('me', authController.me).middleware([AuthenticateMiddleware()]);

    Router.group(() {
      Router.patch('update-password', userController.updatePassword);
      Router.get('', userController.index);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);

    Router.group(() {
      Router.post('todo', todoController.store);
    }, prefix: 'todo', middleware: [AuthenticateMiddleware()]);

    // Routes for CustomersController
    Router.get('/customers', customersController.show);
    Router.get(
        '/customers/{id}', customersController.show); // Get a specific customer
    Router.post('/create-customers',
        customersController.store); // Create a new customer
    Router.put(
        '/customers/{id}', customersController.update); // Update a customer
    Router.delete(
        '/customers/{id}', customersController.destroy); // Delete a customer

    // Routes for ProductController
    Router.get('/products', productsController.show); // Get all products
    Router.get(
        '/products/:id', productsController.show); // Get a specific product
    Router.post(
        '/create-product', productsController.store); // Create a new product
    Router.put('/products/{id}', productsController.update); // Update a product
    Router.delete(
        '/products/{id}', productsController.destroy); // Delete a product

    // Routes for ProductNotesController
    Router.get(
        '/productnotes', productNotesController.show); // Get all product notes
    Router.get('/productnotes/:id',
        productNotesController.show); // Get a specific product note
    Router.post('/create-productnotes',
        productNotesController.store); // Create a new product note
    Router.put('/productnotes/{id}',
        productNotesController.update); // Update a product note
    Router.delete('/productnotes/{id}',
        productNotesController.destroy); // Delete a product note

    // Routes for OrdersController
    Router.get('/orders', ordersController.show); // Get all orders
    Router.get('/orders/:id', ordersController.show); // Get a specific order
    Router.post('/create-orders', ordersController.store); // Create a new order
    Router.put('/orders/{id}', ordersController.update); // Update an order
    Router.delete('/orders/{id}', ordersController.destroy); // Delete an order

    // Routes for OrderItemsController
    Router.get('/orderitems', orderItemsController.show); // Get all order items
    Router.get('/orderitems/:id',
        orderItemsController.show); // Get a specific order item
    Router.post('/create-orderitems',
        orderItemsController.store); // Create a new order item
    Router.put('/orderitems/{id}',
        orderItemsController.update); // Update an order item
    Router.delete('/orderitems/{id}',
        orderItemsController.destroy); // Delete an order item

    // Routes for VendorsController
    Router.get('/vendors', vendorsController.show); // Get all vendors
    Router.get(
        '/vendors/{id}', vendorsController.show); // Get a specific vendor
    Router.post(
        '/create-vendors', vendorsController.store); // Create a new vendor
    Router.put('/vendors/{id}', vendorsController.update); // Update a vendor
    Router.delete(
        '/vendors/{id}', vendorsController.destroy); // Delete a vendor
  }
}
