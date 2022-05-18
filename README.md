# Shipping Adm
**— an application to manage shipping providers for an e-commerce**

:warning:  Project status: ongoing   

### Features
- [x] Authenticate users  
- [x] Admin can register, edit and delete a shipping company  
- [x] Admin can see a list of all shipping companies, and access their details  
- [ ] Shipping Company users can load their company's prices and delays
- [ ] Admin can run a quote to choose a shipping company for a certain delivery
- [ ] Admin can create and destroy a service order to hire a shipping company
- [ ] Shipping Company users can accept or reject service orders
- [ ] Shipping Company users can create, edit and destroy their logistic outposts
- [ ] Shipping Company users can create shipment updates for a certain package
- [ ] Guest users can track a shipment with only a tracking code

### Installation

![This app requires Ruby v.3.1.1 to be installed](https://img.shields.io/static/v1?label=rubyonrails&message=version%203.1.1&color=B61D1D&style=for-the-badge&logo=rubyonrails)

1 - Clone the repository  
`$ git clone git@github.com:kyriri/treinadev8-2shipping.git`

2 - Change to the project directory   
`$ cd treinadev8-2shipping`

3 - Install the gems / dependencies   
`$ bin/setup`

### Running the application

To start the application, on the project directory run:  
`$ rails server`  
The app will become available at the web address http://localhost:3000/ and can be accessed from any browser.  
  
To stop the application, go back to the command line and press `control + C` (or `^ + C` for Mac users).

### Database 

For demonstration purposes, the app comes with some examples already registered on the database. They can be deleted by running the command below on the project directory:   
`$ rails db:reset`   
(please note this will clean all data, not only the pre-loaded items)

### Test suit

On the project directory, run   
`$ rspec`   
  
### Other info
App developed in the context of the [Treinadev](https://treinadev.com.br/) bootcamp
