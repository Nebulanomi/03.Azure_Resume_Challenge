using System; // Basic system functionalities.
using System.IO; // For handling input and output operations.
using System.Threading.Tasks; // For asynchronous programming.
using Microsoft.AspNetCore.Mvc; // For working with ASP.NET Core MVC features.
using System.Configuration; // For handling configuration settings (not actually used in this code).
using Microsoft.Azure.WebJobs.Extensions.CosmosDB; // For integrating Azure Functions with Azure Cosmos DB.
using Microsoft.Azure.WebJobs; // For working with Azure Functions.
using Microsoft.Azure.WebJobs.Extensions.Http; // For working with HTTP triggers in Azure Functions.
using Microsoft.AspNetCore.Http; // For handling HTTP requests and responses.
using Microsoft.Extensions.Logging; // For logging information, errors, etc.
using Newtonsoft.Json; // For handling JSON serialization and deserialization.
using System.Net.Http; // For creating HTTP responses.

namespace Company.Function // The namespace that groups related classes together; should be consistent across your project.
{
    public static class Get_Resume_Counter // The class that contains your Azure Function; declared as static because Azure Functions don't need instances.
    {
        [FunctionName("Get_Resume_Counter")] // Attribute to define the name of the Azure Function.
        public static HttpResponseMessage Run(
            
            // This attribute specifies that the function can be triggered via an HTTP GET or POST request.
            // It takes an HttpRequest object as a parameter, which contains details about the HTTP request.
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            
            // This parameter retrieves the existing JSON document from the Cosmos DB collection and binds it to the 'counter' object.
            // It uses the database name "resume", container name "counter", and a specific document ID and PartitionKey.
            [CosmosDB(databaseName:"resume", containerName:"counter", Connection = "AzureResumeConnectionString", Id = "1", PartitionKey = "1")] Counter counter,
            
            // This output binding will save the updated 'Counter' object back into the Cosmos DB collection.
            [CosmosDB(databaseName:"resume", containerName:"counter", Connection = "AzureResumeConnectionString", Id = "1", PartitionKey = "1")] out Counter updatedCounter,
            ILogger log) // Logger instance to log information during the function's execution.
        {
            // Log information indicating that the function has started processing the request.
            log.LogInformation("C# HTTP trigger function processed a request.");

            // Copy the retrieved counter to the output binding, then increment its Count property.
            updatedCounter = counter;
            updatedCounter.Count += 1;
            
            // Serialize the updated counter object to a JSON string that will be returned in the HTTP response.
            var jsonToReturn = JsonConvert.SerializeObject(updatedCounter);
            
            // Return an HTTP response with status code 200 (OK) and the updated JSON content.
            return new HttpResponseMessage(System.Net.HttpStatusCode.OK)
            {
                Content = new StringContent(jsonToReturn, System.Text.Encoding.UTF8, "application/json") // The JSON is encoded as a string in UTF-8 format and specified as "application/json" content type.
            };
        }
    }
}