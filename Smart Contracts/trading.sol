pragma solidity ^0.4.0;

contract TradingContract {

    //Trading contract beetween DO & DSO
    struct TContract{

        uint id; //autoincrement
        address DO;
        address DSO;
        string ipAndPort;
        uint volume;
        uint openDate;
        uint closeDate;
        uint pricePerGB;
        uint weiLeftToWithdraw;
        uint withdrawAtDate;

    }

  //DSO Data storage owner
  struct DataStorageOwner{

    uint id; //autoincrement

    address ownerAddress;  // Owner Ethereum address;

    uint volume;

    uint pricePerGB;

    string ipAndPort;
  }

 //DO - Data owner
  struct DataOwner{

    uint id; //autoincrement

    address ownerAddress;  // Owner Ethereum address;

    uint volume;

    uint pricePerGB;

    string ipAndPort;
  }


  //List of available DSO waiting for DO proposal
  uint storageIndex = 0;
  DataStorageOwner[] dataStorageList;

  //List of available DO waiting for DSO
  uint ownerIndex = 0;
  DataOwner[] dataOwnerList;

  //List of signed contracts between DO & DSO
  uint tradingIndex = 0;
  TContract[] tradingList;

//Can be executed by DSO only ??? how to organasi this??
//function createStorageContractDSO(address DSO, string ipAndPort, uint volume,uint pricePerGB) returns(bool){
  function createStorageContractDSO(string ipAndPort, uint volume,uint pricePerGB) returns(bool){

        address DSO = msg.sender;
        uint index;
        bool error;
        (index,error) = findData(volume, pricePerGB);

        if(error){
            dataStorageList.push(DataStorageOwner(storageIndex++,DSO, volume, pricePerGB, ipAndPort));
        }else{
            tradingList.push(TContract(
                                tradingIndex++,
                                dataOwnerList[index].ownerAddress,
                                DSO,
                                ipAndPort,
                                volume,
                                0,
                                0,
                                pricePerGB,
                                0,
                                0));

        }



        return true;
  }

    //Can be executed by DO only ???
    //function createStorageContractDO(address DO, string ipAndPort, uint volume,uint pricePerGB) returns(bool){
  function createStorageContractDO( string ipAndPort, uint volume,uint pricePerGB) returns(bool){

        address DO = msg.sender;

        uint index;
        bool error;
        (index,error) = findStorage(volume, pricePerGB);

        if(error){
            dataOwnerList.push(DataOwner(ownerIndex++,DO, volume, pricePerGB, ipAndPort));
        }else{
            tradingList.push(TContract(
                                tradingIndex++,
                                DO,
                                dataStorageList[index].ownerAddress,
                                dataStorageList[index].ipAndPort,
                                volume,
                                0,
                                0,
                                pricePerGB,
                                0,
                                0));

        }

        return true;
  }

//Can be executed only by DO
  function startStorageContract(uint contractId){

  }

//Can be executed by DO and DSO of coresponding contract
  function stopStorageContract(uint contractId){

  }

//can be executed by DO
  function refillStorageContract() payable{

  }

//can be called by DSO only
  function withdrawFromStorageContract(){

  }

//can be called by DO or DSO
  function showMyStorageContracts() constant returns(uint[] DOContracts, uint[] DSOContracts){
        //Probably show contracts by comma???
        
        // for(uint i=0; i < tradingList.length; i++){
            
        //     if(tradingList[i].DO == msg.sender){
        //         DOContracts.push(tradingList[i].id);
        //     }
            
        //     if(tradingList[i].DSO == msg.sender){
        //         DSOContracts += tradingList[i].id + ",";
        //     }
        // }
              
  }

//this function is impossible
//   function showAllStorageContracts(){

//   }


//// UTILITY FUNCTIONS all should be constant

//Return index from dataStorageList
function findStorage(uint volume,uint pricePerGB) private constant returns(uint index, bool error) {
    for(uint i=0; i < dataStorageList.length ;i++){

        if(dataStorageList[i].volume == volume && dataStorageList[i].pricePerGB == pricePerGB){
            return (i, false);
        }

    }

    return (0, true);
}

//Return index from dataOwnerList
function findData(uint volume,uint pricePerGB)private constant returns(uint index, bool error) {

    for(uint i=0; i < dataOwnerList.length;i++){

        if(dataOwnerList[i].volume == volume && dataOwnerList[i].pricePerGB == pricePerGB){
            return (i, false);
        }

    }

    return (0, true);
}



//// FUNCTION FOR THE WEB-Client

function getDataStorageListSize() constant returns(uint){
    return dataStorageList.length;
}

function getDataOwnerListSize() constant returns(uint){
  return dataOwnerList.length;
}

function getTradingListSize() constant returns(uint){
  return tradingList.length;
}

function getStorageByIndex(uint index) constant returns(uint id, address ownerAddress,uint volume, uint pricePerGB,string ipAndPort){
    return (dataStorageList[index].id,
            dataStorageList[index].ownerAddress,
            dataStorageList[index].volume,
            dataStorageList[index].pricePerGB,
            dataStorageList[index].ipAndPort);
}



function getDataByIndex(uint index) constant returns(uint id ,address ownerAddress,uint volume, uint pricePerGB,string ipAndPort){
     return (dataOwnerList[index].id,
             dataOwnerList[index].ownerAddress,
             dataOwnerList[index].volume,
             dataOwnerList[index].pricePerGB,
             dataOwnerList[index].ipAndPort);
}

function getContractByIndex(uint index)constant returns(uint id,address DO,address DSO,string ipAndPort,
                                                     uint volume,uint openDate,uint closeDate,uint pricePerGB,
                                                     uint weiLeftToWithdraw,uint withdrawAtDate){

    TContract trade = tradingList[index];

    return (trade.id,
            trade.DO,
            trade.DSO,
            trade.ipAndPort,
            trade.volume,
            trade.openDate,
            trade.closeDate,
            trade.pricePerGB,
            trade.weiLeftToWithdraw,
            trade.withdrawAtDate);
}

//Return DO index in the dataOwnerList by it is id
function getDataOwnerIndexById(uint id)constant returns(uint index, bool  error){
    
     for(uint i=0; i < dataOwnerList.length;i++){

        if(dataOwnerList[i].id == id){
            return (i, false);
        }

    }

    return (0, true);
    
}

//Return DSO index in the dataStorageList by id
function getDataStorageOwnerIndexById(uint id)constant returns(uint index, bool  error){
    
     for(uint i=0; i < dataStorageList.length;i++){

        if(dataStorageList[i].id == id){
            return (i, false);
        }

    }

    return (0, true);
    
}

//Return contract index by it is id
function getTContractIndexById(uint id)constant returns(uint index, bool  error){
    
     for(uint i=0; i < dataStorageList.length;i++){

        if(dataStorageList[i].id == id){
            return (i, false);
        }

    }

    return (0, true);
    
}




}
