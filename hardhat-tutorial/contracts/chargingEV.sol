// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract ChargingEV {
    struct ChargingDataCollecting {
        uint chargingPileID; //充电桩编号
        uint chargingTimeInMinutes; //以分钟为单位的充电时长
        uint energyUsed; //一次充电的充电量
    }
    
    struct PileHealthReporting {
        uint chargingPileID; //充电桩编号
        bool pileHealth; //充电桩正常运行为true，故障为false
        uint currentTime; //当前时间
    }

    mapping(uint => bool) public ChargingWorkingStatus; //充电桩编号到工作状态（是否开始充电）的映射
    mapping(uint => bool) public PileHealth; //充电桩编号到健康状态的映射

    event ChargingDataCollected(uint chargingPileID, uint chargingTime, uint energyUsed); //数据已上报的事件
    event StartCharging(uint chargingPileID); //开始充电的事件
    event EndChargingandCollectChargingData(uint chargingPileID); //充电结束的事件
    event PileHealthReported(uint chargingPileID, bool healthy, uint currentTime); //健康状态已上报的事件

    // An array of 'Report' structs
    ChargingDataCollecting[] public datas;
    
    // An array of 'Report' structs
    PileHealthReporting[] public reports;

    function startCharging(uint _chargingPileID) public{ //开始充电的函数，充电桩开始充电时执行
        ChargingWorkingStatus[_chargingPileID] = true; //开始充电，将工作状态设为true
        emit StartCharging(_chargingPileID); //触发开始充电的事件
    }
    
    function ReportingPileHealth(uint _chargingPileID, bool _pileHealth, uint _currentTime) public { //健康状态上报函数，充电桩定时上报健康状态时执行
        // 3 ways to initialize a struct
        // - calling it like a function
        PileHealth[_chargingPileID] = _pileHealth; //设置某一充电桩的健康状态
        reports.push(PileHealthReporting(_chargingPileID, _pileHealth, _currentTime)); //上传充电桩编号、健康状态、当前时间三个数据至区块链
        emit PileHealthReported(_chargingPileID, _pileHealth, _currentTime); //触发事件HealthReported
    }

    function endChargingandCollectChargingData(uint _chargingPileID, uint _chargingTimeInMinutes, uint _energyUsed) public { //充电结束及数据收集函数，当充电桩结束充电时执行
        // 3 ways to initialize a struct
        // - calling it like a function
        datas.push(ChargingDataCollecting(_chargingPileID, _chargingTimeInMinutes, _energyUsed)); //上传充电桩编号、充电时间、充电量三个数据
        ChargingWorkingStatus[_chargingPileID] = false; //充电结束，将工作状态设为false
        emit EndChargingandCollectChargingData(_chargingPileID); //触发充电结束的事件
        emit ChargingDataCollected(_chargingPileID, _chargingTimeInMinutes, _energyUsed); //触发数据已上报的事件
    }

    // Solidity automatically created a getter for 'todos' so
    // you don't actually need this function.
    function getChargingData(uint _index) public view returns (uint _chargingPileID, uint _chargingTimeInMinutes, uint _energyUsed) { //数据存储与读取函数
        ChargingDataCollecting storage data = datas[_index]; //存储充电桩编号、充电时长、充电量三个数据
        return (data.chargingPileID, data.chargingTimeInMinutes, data.energyUsed);
    }

    // Solidity automatically created a getter for 'todos' so
    // you don't actually need this function.
    function getPileHealth(uint _index) public view returns (uint _chargingPileID, bool _pileHealth, uint _currentTime) { //数据存储与读取函数
        PileHealthReporting storage report = reports[_index]; //存储充电桩编号、健康状态、当前时间三个数据
        return (report.chargingPileID, report.pileHealth, report.currentTime); 
    }
}
