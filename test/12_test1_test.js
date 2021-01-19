const test1 = artifacts.require('test1.sol');



contract('test1', function(accounts){
  
  
    //******************* Test 1*************************

    // it('should add integers to the array', async() => {
        
    //     const testInstance = await test1.deployed(); 
    //     var receipt = null;
    //     var array = [];
    

    //     for(let j = 1; j <= 3  ; j++){
    //         await testInstance.SubmitInt(j);
    //         array.push(j);
    //     } 
    //     console.log(array.length,'integers have been stored in the contract');
    
    // });
    //******************* Test 2*************************
    
    // it('should return the Gasestimate for killing the contract', async() => {
        
    //     const testInstance = await test1.deployed(); 
    //     const gasEstimate =  await testInstance.Killcontract.estimateGas();
    //     console.log('Gas Estimate is for killing the contract is:', gasEstimate); 
    // });  



    //******************* Test 3*************************

    // it('should kill the contract', async() => {
        
    //     const testInstance = await test1.deployed(); 
    //     var receipt = null;
        
    //     reciept = await testInstance.killcontract();
    //     //console.log(`GasUsed for selfdestructing the contract is : ${receipt.receipt.gasUsed}`); 
    //     console.log(reciept);
    
    // });

    //******************* Test 4*************************
    it('should give the gasUSed for the ChangeVariable function', async() => {
        
        const testInstance = await test1.deployed();  
        const receipt = await testInstance.ChangeVariable();
        console.log(`GasUsed for ChangeVariable function is : ${receipt.receipt.gasUsed}`);
        console.log("***************************************************************") 
        console.log('The transaction receipt is:',receipt);
        
    });
    //******************* Test 5*************************
    it('should give the estimateGas for the ChangeVariable function', async() => {
        
        const testInstance = await test1.deployed(); 
        const estimatedGas = await testInstance.ChangeVariable.estimateGas();
        console.log("***************************************************************")
        console.log("The estimated gas for the ChangeVariable function is:",estimatedGas);
        
    });


})