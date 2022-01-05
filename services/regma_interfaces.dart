abstract class RegmaInterfaces {
  ///{[fsCollection : firebase collection from which data will be retrieved],
  ///[entityInstance : empty instance]}
  ///Retrieve data from Firebase collection "fsCollection" and builds an
  ///Instance of the same type as  entityInstance
  // getInstanceListOf(String fsCollection, dynamic entityInstance);

  // ///Takes data from entity instance and save it to collection fsCollection
  // saveEntity(String fsCollection, Map<String, dynamic> entityInstance,
  //     {bool isSearchable = true,
  //     Map<String, dynamic> additionalJson,
  //     Future then()});

  ///Delete entity
  deleteEntity(String fsCollection, idField, dynamic idValue);

  // /// Search for an entity using its Name
  // Future<dynamic> search(
  //     String keyWord, String fsCollection, dynamic entityEmptyInstance);
}
