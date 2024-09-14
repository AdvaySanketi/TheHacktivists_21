import axios from "axios"
import React, { useEffect, useRef, useState } from "react"
import { Line } from 'react-chartjs-2';

import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Tooltip,
    Legend,
} from 'chart.js';

ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Tooltip,
    Legend
);

export default function OverviewSec () {

    const [reqData, setReqData] = useState<InternalData | null>(null);
    const [chartData, setChartData] = useState<ChartDataInf>({
        labels: [],
        datasets: [],
    });
    const [chartOptions, setChartOptions] = useState<any>({
        plugins: {
            legend: {
                position: 'top',
            },
        },
        maintainAspectRatio: false,
        responsive: true
    });

    const chartRef = useRef(null);

    interface RevenueData {
        month: string,
        revenue: number
    }

    interface InternalData {
        total_users: DateValue,
        total_orders: DateValue,
        total_vendors: DateValue,
        total_earnings: DateValue,
        revenue_data: RevenueData[]
    }

    interface DateValue {
        value: number,
        percentage: number
    }

    interface DataProp {
        label: string,
        data: number[],
        borderColor: string,
        backgroundColor: string,
        fill: boolean
    }

    interface ChartDataInf {
        labels: string[],
        datasets: DataProp[]
    }

    useEffect(() => {
        const getData = async () => {
            try {
                const response = await axios.get(`http://localhost:5000/data`,{
                    headers:{'Content-type':'application/json'}
                });
                const data = response.data;

                const months = data.revenue_data.map((entry: RevenueData) => entry.month);
                const revenues = data.revenue_data.map((entry: RevenueData) => entry.revenue);

                setReqData(data);
                setChartData({
                    labels: months,
                    datasets: [
                        {
                            label: 'Monthly Revenue',
                            data: revenues,
                            borderColor: '#004aac',
                            backgroundColor: 'rgba(0, 74, 172, 0.3)',
                            fill: true,
                        }
                    ]
                });
            } catch (error) {
                console.log("Error fetching data",error);
            }
        }
        getData();  
    },[])

    return(
        <div className="w-[100%] h-screen">
            <div className="flex justify-between items-center px-6 py-3 border-b-gray-200 border-b-2">
                <div className="text-black text-xl font-extrabold">Overview</div>
                <div className="flex items-center gap-2 border-gray-300 border-2 px-2 py-1 rounded-lg cursor-pointer text-gray-500 hover:text-gray-800">
                    <div>
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-filter size-3">
                            <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/>
                        </svg>
                    </div>
                    <div className="text-sm font-semibold">Filter</div>
                </div>
            </div>
            <div className="bg-gray-50 px-6 py-3">
                {reqData==null ? (
                    <div className="flex w-[100%] justify-around mt-4">
                        <div className="p-4 bg-white rounded-xl shadow-md w-[15rem] h-[10rem] animate-pulse"></div>
                        <div className="p-4 bg-white rounded-xl shadow-md w-[15rem] h-[10rem] animate-pulse"></div>
                        <div className="p-4 bg-white rounded-xl shadow-md w-[15rem] h-[10rem] animate-pulse"></div>
                        <div className="p-4 bg-white rounded-xl shadow-md w-[15rem] h-[10rem] animate-pulse"></div>
                    </div>
                ) : (
                    <div className="flex w-[100%] justify-around mt-4">
                        <div className="p-4 border-gray-200 border-2 bg-white rounded-xl shadow-lg">
                            <div className="font-semibold text-gray-500">Total Users</div>
                            <div className="text-3xl font-extrabold my-4">&#8377; {reqData?.total_users.value}</div>
                            <div className="flex justify-between items-center gap-2">
                                <div className={`flex gap-1 justify-start items-center rounded-lg bg-[#f6d9dd] ${reqData.total_users.percentage > 0 ? "bg-[#f6d9dd]" : "bg-red-400"} p-1`}>
                                    <div className="animate-bounce">
                                        {reqData.total_users.percentage > 0 ? (
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-arrow-up size-4">
                                                <path d="m5 12 7-7 7 7"/>
                                                <path d="M12 19V5"/>
                                            </svg>
                                        ) : (
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-arrow-down size-4">
                                                <path d="M12 5v14"/>
                                                <path d="m19 12-7 7-7-7"/>
                                            </svg>
                                        )}
                                    </div>
                                    <div className="text-sm">{reqData?.total_users.percentage} %</div>
                                </div>
                                <div className="text-xs">Compared to last month</div>
                            </div>
                        </div>
                        <div className="p-4 border-gray-200 border-2 bg-white rounded-xl shadow-lg">
                            <div className="font-semibold text-gray-500">Total Orders</div>
                            <div className="text-3xl font-extrabold my-4">&#8377; {reqData?.total_orders.value}</div>
                            <div className="flex justify-between items-center gap-2">
                                <div className={`flex gap-1 justify-start items-center rounded-lg bg-[#f6d9dd] ${reqData.total_orders.percentage > 0 ? "bg-[#f6d9dd]" : "bg-red-400"} p-1`}>
                                <div className="animate-bounce">
                                        {reqData.total_orders.percentage > 0 ? (
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-arrow-up size-4">
                                                <path d="m5 12 7-7 7 7"/>
                                                <path d="M12 19V5"/>
                                            </svg>
                                        ) : (
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-arrow-down size-4">
                                                <path d="M12 5v14"/>
                                                <path d="m19 12-7 7-7-7"/>
                                            </svg>
                                        )}
                                    </div>
                                    <div className="text-sm">{reqData?.total_orders.percentage} %</div>
                                </div>
                                <div className="text-xs">Compared to last month</div>
                            </div>
                        </div>
                        <div className="p-4 border-gray-200 border-2 bg-white rounded-xl shadow-lg">
                            <div className="font-semibold text-gray-500">Total Vendors</div>
                            <div className="text-3xl font-extrabold my-4">&#8377; {reqData?.total_vendors.value}</div>
                            <div className="flex justify-between items-center gap-2">
                                <div className={`flex gap-1 justify-start items-center rounded-lg bg-[#f6d9dd] ${reqData.total_vendors.percentage > 0 ? "bg-[#f6d9dd]" : "bg-red-400"} p-1`}>
                                <div className="animate-bounce">
                                        {reqData.total_vendors.percentage > 0 ? (
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-arrow-up size-4">
                                                <path d="m5 12 7-7 7 7"/>
                                                <path d="M12 19V5"/>
                                            </svg>
                                        ) : (
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-arrow-down size-4">
                                                <path d="M12 5v14"/>
                                                <path d="m19 12-7 7-7-7"/>
                                            </svg>
                                        )}
                                    </div>
                                    <div className="text-sm">{reqData?.total_vendors.percentage} %</div>
                                </div>
                                <div className="text-xs">Compared to last month</div>
                            </div>
                        </div>
                        <div className="p-4 border-gray-200 border-2 bg-white rounded-xl shadow-lg">
                            <div className="font-semibold text-gray-500">Total Earnings</div>
                            <div className="text-3xl font-extrabold my-4">&#8377; {reqData?.total_earnings.value}</div>
                            <div className="flex justify-between items-center gap-2">
                                <div className={`flex gap-1 justify-start items-center rounded-lg bg-[#f6d9dd] ${reqData.total_earnings.percentage > 0 ? "bg-[#f6d9dd]" : "bg-red-400"} p-1`}>
                                <div className="animate-bounce">
                                        {reqData.total_earnings.percentage > 0 ? (
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-arrow-up size-4">
                                                <path d="m5 12 7-7 7 7"/>
                                                <path d="M12 19V5"/>
                                            </svg>
                                        ) : (
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-arrow-down size-4">
                                                <path d="M12 5v14"/>
                                                <path d="m19 12-7 7-7-7"/>
                                            </svg>
                                        )}
                                    </div>
                                    <div className="text-sm">{reqData?.total_earnings.percentage} %</div>
                                </div>
                                <div className="text-xs">Compared to last month</div>
                            </div>
                        </div>
                    </div>
                )}
                {reqData==null ? (
                    <div className="p-4 mt-8 bg-white rounded-xl shadow-md h-[15rem] animate-pulse"></div>
                ) : (
                    <div className="p-4 my-8 border-gray-200 border-2 bg-white rounded-xl shadow-lg">
                        <div className="h-[15rem]">
                            <Line data={chartData} ref={chartRef} options={chartOptions} />
                        </div>
                    </div>
                )}
            </div>
        </div>
    )
}