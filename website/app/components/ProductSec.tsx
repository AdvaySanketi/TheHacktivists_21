import Img1 from '../images/img1.jpg';
import Img2 from '../images/img2.jpg';
import Img3 from '../images/img3.jpg';
import Img4 from '../images/img4.jpg';
import Img5 from '../images/img5.jpg';

export default function ProductSec () {

    return(
        <div className="w-[100%] h-max">
            <div className="flex justify-between items-center px-6 py-3 border-b-gray-200 border-b-2">
                <div className="text-black text-xl font-extrabold">Products</div>
            </div>
            <div className='flex bg-gray-50 justify-between p-8'>
                <div className='w-max'>
                    <div 
                        className="prop w-[15rem] h-[21rem] cursor-pointer object-cover transition-transform duration-300 ease-in-out transform hover:scale-105"
                        style={{ backgroundImage: `url(${Img4.src})` }}
                    ></div>
                    <div className='flex justify-between items-start mt-3'>
                        <div className='text-sm'>
                            <div className='font-semibold'>Water Bottle</div>
                            <div>Home accessories</div>
                        </div>
                        <div className='text-sm'>&#8377; 78.99</div>
                    </div>
                </div>
                <div className='w-max'>
                    <div 
                        className="prop w-[15rem] h-[21rem] cursor-pointer object-cover transition-transform duration-300 ease-in-out transform hover:scale-105"
                        style={{ backgroundImage: `url(${Img3.src})` }}
                    ></div>
                    <div className='flex justify-between items-start mt-3'>
                        <div className='text-sm'>
                            <div className='font-semibold'>Backpack</div>
                            <div>Personal accessories</div>
                        </div>
                        <div className='text-sm'>&#8377; 78.99</div>
                    </div>
                </div>
                <div className='w-max'>
                    <div 
                        className="prop w-[15rem] h-[21rem] cursor-pointer object-cover transition-transform duration-300 ease-in-out transform hover:scale-105"
                        style={{ backgroundImage: `url(${Img2.src})` }}
                    ></div>
                    <div className='flex justify-between items-start mt-3'>
                        <div className='text-sm'>
                            <div className='font-semibold'>Clay pot</div>
                            <div>Home accessories</div>
                        </div>
                        <div className='text-sm'>&#8377; 500.99</div>
                    </div>
                </div>
                <div className='w-max'>
                    <div 
                        className="prop w-[15rem] h-[21rem] cursor-pointer object-cover transition-transform duration-300 ease-in-out transform hover:scale-105"
                        style={{ backgroundImage: `url(${Img1.src})` }}
                    ></div>
                    <div className='flex justify-between items-start mt-3'>
                        <div className='text-sm'>
                            <div className='font-semibold'>Carpet</div>
                            <div>Home accessories</div>
                        </div>
                        <div className='text-sm'>&#8377; 890.99</div>
                    </div>
                </div>
            </div>
            <div className='flex bg-gray-50 justify-between p-8'>
                <div className='w-max'>
                    <div 
                        className="prop w-[15rem] h-[21rem] cursor-pointer object-cover transition-transform duration-300 ease-in-out transform hover:scale-105"
                        style={{ backgroundImage: `url(${Img4.src})` }}
                    ></div>
                    <div className='flex justify-between items-start mt-3'>
                        <div className='text-sm'>
                            <div className='font-semibold'>Water Bottle</div>
                            <div>Home accessories</div>
                        </div>
                        <div className='text-sm'>&#8377; 78.99</div>
                    </div>
                </div>
                <div className='w-max'>
                    <div 
                        className="prop w-[15rem] h-[21rem] cursor-pointer object-cover transition-transform duration-300 ease-in-out transform hover:scale-105"
                        style={{ backgroundImage: `url(${Img3.src})` }}
                    ></div>
                    <div className='flex justify-between items-start mt-3'>
                        <div className='text-sm'>
                            <div className='font-semibold'>Backpack</div>
                            <div>Personal accessories</div>
                        </div>
                        <div className='text-sm'>&#8377; 78.99</div>
                    </div>
                </div>
                <div className='w-max'>
                    <div 
                        className="prop w-[15rem] h-[21rem] cursor-pointer object-cover transition-transform duration-300 ease-in-out transform hover:scale-105"
                        style={{ backgroundImage: `url(${Img2.src})` }}
                    ></div>
                    <div className='flex justify-between items-start mt-3'>
                        <div className='text-sm'>
                            <div className='font-semibold'>Clay pot</div>
                            <div>Home accessories</div>
                        </div>
                        <div className='text-sm'>&#8377; 500.99</div>
                    </div>
                </div>
                <div className='w-max'>
                    <div 
                        className="prop w-[15rem] h-[21rem] cursor-pointer object-cover transition-transform duration-300 ease-in-out transform hover:scale-105"
                        style={{ backgroundImage: `url(${Img1.src})` }}
                    ></div>
                    <div className='flex justify-between items-start mt-3'>
                        <div className='text-sm'>
                            <div className='font-semibold'>Carpet</div>
                            <div>Home accessories</div>
                        </div>
                        <div className='text-sm'>&#8377; 890.99</div>
                    </div>
                </div>
            </div>
        </div>
    )
}