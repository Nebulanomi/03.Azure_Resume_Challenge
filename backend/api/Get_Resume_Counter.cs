using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Configuration;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http;

namespace Company.Function
{
    public static class Get_Resume_Counter
    {
        [FunctionName("Get_Resume_Counter")]
        public static HttpResponseMessage Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            [CosmosDB(databaseName:"Azure Resume", containerName:"Counter", Connection = "AzureResumeConnectionString", Id = "1", PartitionKey = "1")] Counter counter,
            [CosmosDB(databaseName:"Azure Resume", containerName:"Counter", Connection = "AzureResumeConnectionString", Id = "1", PartitionKey = "1")] out Counter updatedcounter,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            updatedcounter = counter;
            updatedcounter.Count += 1;
            
            var jsonToRetun = JsonConvert.SerializeObject(updatedcounter);
            
            return new HttpResponseMessage(System.Net.HttpStatusCode.OK)
            {
                Content = new StringContent(jsonToRetun, System.Text.Encoding.UTF8, "application/json")
            };
        }
    }
}
