import Image from 'next/image';

import Pic1 from './images/pic1.jpg';
import Pic2 from './images/pic2.jpg';
import Bg from './images/Swipe-bgless.png';

export default function Home() {
  return (
    <div 
      className="flex justify-center items-center w-screen h-screen p-20 bg-no-repeat bg-cover bg-center"
      style={{ backgroundImage: `url(${Pic2.src})` }}
    >
      <div className='flex rounded-2xl w-[100%] h-[100%] overflow-hidden border-[0.1rem] border-gray-400'>

        <div className='w-[50%] flex justify-center items-center h-[100%] bg-slate-900 bg-gradient-to-br from-gray-900 to-gray-700'>
          <div className='flex-col justify-center items-center'>
            <div className='text-4xl mb-8'>Sign Up</div>
            <div className='mb-4'>
              <div className="relative">
                <div className="absolute inset-y-0 start-0 flex items-center ps-3.5 pointer-events-none">
                  <svg className="w-4 h-4 text-gray-500 dark:text-gray-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 16">
                      <path d="m10.036 8.278 9.258-7.79A1.979 1.979 0 0 0 18 0H2A1.987 1.987 0 0 0 .641.541l9.395 7.737Z"/>
                      <path d="M11.241 9.817c-.36.275-.801.425-1.255.427-.428 0-.845-.138-1.187-.395L0 2.6V14a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V2.5l-8.759 7.317Z"/>
                  </svg>
                </div>
                <input type="text" id="input-group-1" className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full ps-10 p-2.5  dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="Enter your email id"/>
              </div>
            </div>
            <div>
              <div className="mb-4">
                  <input type="password" id="password" className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="Enter your password" required />
              </div> 
            </div>
            <a href='/dashboard'>
              <div className='py-2 px-4 mt-8 rounded-lg border-[0.1rem] border-gray-400 hover:bg-gray-300 hover:text-gray-700 cursor-pointer'>Proceed</div>
            </a>
          </div>
        </div>
        <div 
          className='w-[50%] h-[100%] bg-yellow-500 bg-no-repeat bg-cover bg-center p-36'
          style={{ backgroundImage: `url(${Pic1.src})` }}
        >
          <div className='glass rounded-2xl w-[100%] h-[100%]'>
            <Image src={Bg} alt='background_pic' className='mt-4 w-[90%]'/>
            <div className='glass w-[50%] h-[50%] absolute -bottom-16 -left-8 rounded-lg'></div>
          </div>
        </div>
      </div>
    </div>
  );
}