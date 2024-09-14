import Image from 'next/image';
import { Quicksand } from 'next/font/google';

import LogoPic from '../images/logo.jpeg';

const inter = Quicksand({
    weight: '400',
    subsets: ['latin'],
    display: 'swap',
})

interface SideProps {
    setIndex: React.Dispatch<React.SetStateAction<number>>
}

export default function SidebarSec ({setIndex}: SideProps) {
    return(
        <div className={`${inter.className} bg-white fixed w-[16rem] h-[100%] border-r-gray-200 border-r-2`}>
            <div className='flex-col justify-between h-[90%]'>
                <div className='flex justify-start items-center px-6 py-4'>
                    <Image src={LogoPic} alt='logo' className='w-10 cursor-pointer mix-blend-luminosity'/>
                    <div className='text-xl font-bold ml-4'>Swipe</div>
                </div>

                <div className='text-gray-500 text-sm mx-6 mt-6'>
                    <div className='mb-4 px-4'>MAIN MENU</div>
                    <div className='flex justify-start items-center gap-2 p-4 py-2 hover:text-white hover:bg-[#287e71] hover:rounded-lg cursor-pointer' onClick={() => setIndex(0)}>
                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-layout-grid">
                                <rect width="7" height="7" x="3" y="3" rx="1"/>
                                <rect width="7" height="7" x="14" y="3" rx="1"/>
                                <rect width="7" height="7" x="14" y="14" rx="1"/>
                                <rect width="7" height="7" x="3" y="14" rx="1"/>
                            </svg>
                        </div>
                        <div className='font-semibold'>Overview</div>
                    </div>
                    <div className='flex justify-start mt-2 items-center gap-2 p-4 py-2 hover:text-white hover:bg-[#287e71] hover:rounded-lg cursor-pointer' onClick={() => setIndex(1)}>
                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-shopping-bag">
                                <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/>
                                <path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/>
                            </svg>
                        </div>
                        <div className='font-semibold'>Orders</div>
                    </div>
                    <div className='flex justify-start mt-2 items-center gap-2 p-4 py-2 hover:text-white hover:bg-[#287e71] hover:rounded-lg cursor-pointer' onClick={() => setIndex(2)}>
                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-box">
                                <path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/>
                                <path d="m3.3 7 8.7 5 8.7-5"/>
                                <path d="M12 22V12"/>
                            </svg>  
                        </div>
                        <div className='font-semibold'>Products</div>
                    </div>
                </div>

                <div className='bg-gray-200 h-[0.2rem] rounded-xl mx-6 my-6'></div>

                <div className='text-gray-500 text-sm mx-6 mt-6'>
                    <div className='flex justify-start items-center gap-2 p-4 py-2 hover:text-white hover:bg-[#287e71] hover:rounded-lg cursor-pointer'>
                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-rocket">
                                <path d="M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z"/>
                                <path d="m12 15-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.35 22.35 0 0 1-4 2z"/>
                                <path d="M9 12H4s.55-3.03 2-4c1.62-1.08 5 0 5 0"/>
                                <path d="M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5"/>
                            </svg>
                        </div>
                        <div className='font-semibold'>Feedback</div>
                    </div>
                    <div className='flex justify-start mt-2 items-center gap-2 p-4 py-2 hover:text-white hover:bg-[#287e71] hover:rounded-lg cursor-pointer'>
                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-info">
                                <circle cx="12" cy="12" r="10"/>
                                <path d="M12 16v-4"/>
                                <path d="M12 8h.01"/>
                            </svg>
                        </div>
                        <div className='font-semibold'>Help and Docs</div>
                    </div>
                </div>
            </div>
            <div className='flex justify-start mx-6 mt-2 text-gray-500 text-sm items-center gap-2 p-4 hover:text-white hover:bg-[#287e71] hover:rounded-lg cursor-pointer'>
                <div>
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-log-out">
                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                        <polyline points="16 17 21 12 16 7"/><line x1="21" x2="9" y1="12" y2="12"/>
                    </svg>
                </div>
                <a href='/'>
                <div className='font-semibold'>Logout</div>
                </a>
            </div>
        </div>
    )
}