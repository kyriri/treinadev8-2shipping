# Shipping Adm
**— an application to manage shipping providers for an e-commerce**

:warning:  Project status: ongoing   

### Features
- [x] Users and admins can log in  
- [x] Admin can register, view, edit and delete a Shipping Company  
- [x] User can edit some info about their own company  
- [ ] Shipping Company users can load their company's prices and delays
- [x] Admin can request quotes and choose a shipping company for a certain delivery
- [x] Shipping Company users can accept or reject service orders
- [ ] Shipping Company users can create, edit and destroy their logistic outposts
- [x] Shipping Company users can create shipment updates for a certain package
- [x] Guest users can track a shipment with only a tracking code

### Entities

This app intends to help manage the relationship between an e-commerce and its many shipping providers.

A **Shipping Company** is one such provider. It can be *in registration*, *suspended* or *active*. Only active companies participate in the quoting process, and for this they are required to provide their tables of **Shipping Rate**s and **Delivery Time**s, as well as a factor for calculation of cubic weight and their minimal fee.

**User** is the model managing access to the application. The role of *admin* is designed for an employee of the e-commerce who obtains quotes and distributes service orders, whereas the role of *user* is designed for an employee of a shipping company who accepts or rejects orders on its behalf, and who provides updates for ongoing deliveries.

A **Package** is the information this app receives from another part of the e-commerce system. It is immediately tied to an **Service Order** after reception.

The **Service Order** is the main object of the app. Its status tracks its life: it starts as *unassigned*, changes to *pending* when a shipping company is offered the shipping service, and then changes to *accepted* or *rejected* according to the shipping company response. Its end-of-life options are *canceled*, or, more happily, *delivered*. 

To help admins on their task to choose a shipping company, they can run a **Quote**, which will retrieve prices and delivery times from all active companies for a given package. Each set of quotes is recorded and can be audited anytime.

When a shipping company accepts a service order, a **Delivery** is created, which records the **Stage**s of delivery, that is, the route of a package through the many **Outpost**s of a shipping company. This information can be accessed with a link by an unlogged person, and is intended to allow the costumers of the e-commerce to track their buys.

### Installation

![This app requires Ruby 3.1.1 to be installed](https://img.shields.io/static/v1?label=ruby&message=version%203.1.1&color=B61D1D&style=for-the-badge&logo=ruby)

1 - Clone the repository  
`$ git clone git@github.com:kyriri/treinadev8-2shipping.git`

2 - Change to the project directory   
`$ cd treinadev8-2shipping`

3 - Install the gems / dependencies   
`$ bin/setup`

### Running the application

To start the application, on the project directory run:  
`$ bin/rails server`  
The app will become available at the web address http://localhost:3000/ and can be accessed from any browser.  
  
To stop the application, go back to the window where you started the application and press `control + C` (or `^ + C` for Mac users).  

### Demo

If you want to see the application running with some mock data, go to the project directory and run  
`$ bin/rails db:seed`  
  
This will acivate the following credentials:   
- admin: admin@email.com, password: 123456  
- user :  user@email.com, password: 123456  
  
And also creates some packages already in process of delivery, such as: http://localhost:3000/deliveries/HU876592369BR  
  
If you want to clean the mock data, you can go to the project directory and run  
`$ bin/rails db:reset`  
(please note this delete all data, not only the demo items)  

### Test suit

On the project directory, run   
`$ bin/bundle exec rspec`   
  
### Other info
App developed in the context of the [Treinadev](https://treinadev.com.br/) bootcamp
