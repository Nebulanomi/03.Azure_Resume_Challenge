# Azure Resume Challenge:

My own Azure resume, following [ACG project video](https://www.youtube.com/watch?v=ieYrBWmkfno).  
Link to it: [My Resume Website](https://www.alexandrepereira.site/).

## Diagram:

![Alt text](diagram.png)

## Prerequisites:

- Created a [GitHub account](https://github.com/join).
  - To deploy all the files do CI/CD.
- Created an [Azure account](https://azure.microsoft.com/en-us/free).
  - To deploy the website and Azure Function.
- Installed [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
  - Used to create/manage Azure resources locally.
- Installed [.NET Core 8 LTS](https://dotnet.microsoft.com/download/dotnet/8.0).
  - The framework to be used to develop the Azure Function.
- Installed [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=macos%2Ccsharp%2Cbash#install-the-azure-functions-core-tools).
  - To develop and test functions on the local computer. 
- Installed the latest stable [Visual Studio Code](https://code.visualstudio.com).
  - The code editor used for the frontend and backend programming.
- Installed the following [Visual Studio Code Extensions](https://code.visualstudio.com/docs/introvideos/extend):
  - [Azure Functions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions).
    - To create, debug, manage and deploy serverless apps directly from VS Code.
  - [C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp).
    - To have support and be able to program in C#.
  - [Azure Storage](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurestorage).
    - To deploy the static website.

## Building the frontend:

The frontend is a static website with HTML, CSS and JavaScript.  
The visitor counter data is fetched via an API call to an Azure Function.

- Set up the version control.
  - Created a GitHub repository & cloned the starter code ([frontend & backend folders](https://github.com/ACloudGuru-Resources/acg-project-azure-resume)).
  - The frontend folder has the following: css folder, images folder, javascript folder & index.html file.
  - The backend folder has the following: api & tests folders.

- Updated the HTML and implemented a counter.
  - Updated the HTML with my resume information.
  - Created a function.js file and wrote the JavaScript code for the visitor counter.
    - This will grab the JSON that is provided by the Function API and provide it in the HTML where id="counter".
    - This [article](https://www.digitalocean.com/community/tutorials/how-to-use-the-javascript-fetch-api-to-get-data) explains how to make an API call with JavaScript by using the Fetch API.

- Viewed the website locally and pushed all the changes to GitHub.

## Building the backend:

The backend includes the Azure Function with Cosmos DB input and output binding and the tests that are made to validate the code.  

- Set up the Cosmos DB resource.
  - Created a Cosmos DB account, database, container & data.
  - Create a Cosmos DB account via the [portal](https://docs.microsoft.com/en-us/azure/cosmos-db/create-cosmosdb-resources-portal).
  - The data inside the container: {"id": "1", "count": 0}

- Set up the local Azure Function.
  - Created an [HTTP Triggered](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp) Azure Function in the api folder with the Azure Function Extension.  
    - An [HTTP trigger](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=csharp) is used to invoke the Function with an HTTP request.
  - It result is a new .cs file (Get_Resume_Counter.cs).

- Executed: func host start
  - This is to verify that the function works locally.
  
- Added CosmosDB functionality to get counter data:
  - Installed the NuGet package in the api folder to work with CosmosDB.
  
- Created a new .cs file (Counter.cs) for the counter object.
  - This is to get and set the information from the CosmosDB.

- Configured Bindings in the Get_Resume_Counter.cs file which are used to connect other resources to the Function, in this case CosmosDB.
  - [Azure Functions Cosmos DB bindings](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2)
  - [Retrieve a Cosmos DB item with Functions binding.](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2-input?tabs=csharp)
  - [Write to a Cosmos DB item with Functions binding.](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2-output?tabs=csharp)

- Configured the Function code to retreive the counter, update it and return it as JSON.
- Executed: func host start
  - This is to verify that the counter increments.

## Connecting the frontend with the backend:

- Altered the API URL to the Functions local URL.
- Enabled [CORS](https://github.com/Azure/azure-functions-host/issues/1012) in the local Azure Function.
- Executed: func host start
  - Verified that the counter in the HTML increased with every refresh.

- When we access the website the following happens:  
  1. Function is triggered.
  2. It retrieves the CosmosDB item.
  3. Adds +1 to counter in the CosmosDB.
  4. Saves it and returns the new value to the caller.

## Deploying to Azure:

- Deployed the [Azure Function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-how-to-use-azure-function-app-settings?tabs=portal#cors) in VS to Azure (It will deploy everything in the api folder).
- Added a new Application setting in the Function with the Storage Account URL which includes the access keys.
  - Updated the Javascript code with the new Function URL.
  - Enabled [CORS](https://github.com/Azure/azure-functions-host/issues/1012) in the Azure Function.

- Deploy the static website to Blob Container.
  - Deployed frontend folder as a [static website to blob storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website-host).
- Enabled CORS on the Function to allow the storage URL.
- Setup Azure CDN for HTTPS & custom domain support.
  - This cashes our website all over the world.
  - Created a domain name with namecheap.com and added it to Azure CDN.
  - Connected the CDN with the Azure static website url.
  - Enabled HTTPS on CDN & CORS on the Function to allow the domain URL.

### Caching and purging:

- Caching: It is the process of storing copies of files in a cache, or temporary storage location, so that it can be accessed more quickly.
- Purging: It is the process of removing cached content before the predetermined expiry date.
- Purge as part of CI/CD: Incorporating a purge in the pipeline since it's a good practice to ensure visitors get the most up to date assets.

## Building CI/CD pipeline with GitHub:

- Why CI/CD is important:
  - Version control: Track and manage changes to software code.
  - Continuous Integration: Integrate code changes wehre build and tests can run.
  - Continuous Delivery: Code that has passed testing is staged and ready to be pushed to production.
  - Continuous Deployment: Optionally, code that has passed every stage can be automatically pushed to production.

- Created a hidden directory: .github/workflows
  - Created a frontend yaml file.
  - Created a backend yaml file.

- Added a new RBAC user with the contributor role to the resource group level with Azure CLI.
  - Stored the JSON information in the GitHub repository secrets tab.

- Created the frontend workflow.
  - Set up a [GitHub Actions workflow](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-static-site-github-actions) in frontend.main.yml to deploy the frontend static website.

- Implemented a [CI workflow in GitHub Actions](https://docs.github.com/en/actions/guides/building-and-testing-net) to build and test the .NET backend everytime a change is uploaded.

- Why [unit tests](https://dev.to/flippedcoding/its-important-to-test-your-code-3lid) are important:
  - It saves hours of debugging (Only code that passes the test is sent).
  - Improved documentation (A unit test is a small piece of code that describes a user story or requirement).
  - Write more efficient code (Helps to keep code simple because we write just enough code to pass the test).
  - Reduces errors during deployments (We will catch any last-minute issues before we deploy).

- Moved in to the tests folder.
- Executed: dotnet new xunit
  - This creates a test unit project (tests.csproj).
  - [Getting Started with xUnit.net.](https://xunit.net/docs/getting-started/netcore/cmdline).
  - [How to setup Xunit with Azure Functions.](https://madebygps.com/how-to-use-xunit-with-azure-functions/).

- Added a package Microsoft.AspNetCore.Mvc
- Added a reference to the Function app: dotnet add reference  ../api/api.csproj
-Tested the file UnitTest1.cs that was created: dotnet test
  - It will show if it passed or not.
  - Deleted it because it wasnt going to be used anymore.
  
- Pasted the files in the [starter code](https://github.com/ACloudGuru-Resources/acg-project-azure-resume-starter/tree/main/tests) to the tests folder.
  - They are mostly helper files.

- Accessed the TestCounter.cs file.
  - For the test to pass the FACT needs to be true.
  - It has the same information as Counter.cs, therefore if it passes, the files are sent.
  - Execute to test: dotnet test
  - We should also test if it fails.

- Implemented the unit tests to the backend workflow.
  - Set up A [GitHub Actions Workflow](https://learn.microsoft.com/en-us/azure/azure-functions/functions-how-to-github-actions?tabs=windows%2Cdotnet&pivots=method-manual)to create the backend.main.yml.