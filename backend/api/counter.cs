using Newtonsoft.Json; // Importing the Newtonsoft.Json library to handle JSON serialization and deserialization.

namespace Company.Function // Defines the namespace, which should match the one used in the Get_Resume_Counter function for consistency.
{
    public class Counter // Declares a public class named Counter, which represents the structure of the data stored in the Cosmos DB.
    {
        // This attribute maps the "id" field in the JSON document to the Id property in this class.
        [JsonProperty(PropertyName = "id")] 
        public string Id { get; set; } // A property to store the "id" value from the JSON document, which typically identifies the document in the database.

        // This attribute maps the "count" field in the JSON document to the Count property in this class.
        [JsonProperty(PropertyName = "count")]
        public int Count { get; set; } // A property to store the "count" value from the JSON document, which typically represents the visit count in this scenario.
    }
}