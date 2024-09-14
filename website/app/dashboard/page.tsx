"use client"

import { useState } from "react";

import SidebarSec from "../components/SidebarSec";
import OverviewSec from "../components/OverviewSec";
import OrdersSec from "../components/OrderSec";
import ProductSec from "../components/ProductSec";
import { Quicksand } from 'next/font/google';

const quicksand = Quicksand({
    weight: '400',
    subsets: ['latin'],
    display: 'swap',
})

export default function Dashboard() {
  const [index, setIndex] = useState<number>(0);
  const compList = [<OverviewSec key="0"/>, <OrdersSec key="2"/>, <ProductSec key="3"/>]

  return (
    <div className={`flex bg-white w-[100%] h-[65rem] text-gray-700 ${quicksand.className}`}>
      <div>
        <SidebarSec setIndex={setIndex}/>
      </div>
      <div className=" absolute right-0 w-[81.8%]">
        <div className=" flex justify-between p-6 py-4 items-center w-[100%] border-b-gray-200 border-b-2">
          <div className="text-2xl font-extrabold">Good morning, Abhijith!</div>
          <div className="flex items-center divide-x-2">
            <div className="hover:animate-rotate hover:rotate-90 transition-transform duration-1000 cursor-pointer">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-settings">
                <path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"/>
                <circle cx="12" cy="12" r="3"/>
              </svg>
            </div>
            <div className="pl-4 ml-4">
              <div className="flex justify-center items-center text-gray-100 text-xl w-[1rem] h-[1rem] rounded-full bg-gray-500 p-5">A</div>
            </div>
          </div>
        </div>
        {compList[index]}
      </div>
    </div>
  );
}
