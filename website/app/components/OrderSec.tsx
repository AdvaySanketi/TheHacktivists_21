export default function OrdersSec () {

    return(
        <div className="w-[100%] h-screen">
            <div className="flex justify-between items-center px-6 py-3 border-b-gray-200 border-b-2">
                <div className="text-black text-xl font-extrabold">Orders</div>
            </div>
            <div className="bg-gray-50">
                <div className='overflow-auto rounded-lg shadow hidden md:block mb-5'>
                    <table className='w-full text-black'>
                        <thead className='bg-gray-50 border-b-2 border-gray-200'>
                        <tr>
                            <th className='p-3 text-sm font-semibold tracking-wide text-left'>Customer ID</th>
                            <th className='p-3 text-sm font-semibold tracking-wide text-left'>Use ID</th>
                            <th className='p-3 text-sm font-semibold tracking-wide text-left'>Name</th>
                            <th className='p-3 text-sm font-semibold tracking-wide text-left'>Category</th>
                            <th className='p-3 text-sm font-semibold tracking-wide text-left'>Order placed on</th>
                            <th className='p-3 text-sm font-semibold tracking-wide text-left'>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                            <tr>
                            <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>JeUnwf</td>
                            <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Ujnnjk</td>
                            <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>BackPack</td>
                            <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Home accessories</td>
                            <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>12-11-2020</td>
                            <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Successful</td>
                            </tr>
                            <tr>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>FbYiop</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>WxYzmn</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Laptop Bag</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Office Supplies</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>05-03-2021</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Pending</td>
                            </tr>

                            <tr>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>QrZtcp</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>VxzNrt</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Coffee Mug</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Kitchenware</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>14-08-2019</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Successful</td>
                            </tr>

                            <tr>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>LaQmnv</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>XpNbgf</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Gaming Chair</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Furniture</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>22-06-2022</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Failed</td>
                            </tr>

                            <tr>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>MtWygd</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>LxyKgt</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Wireless Headphones</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Electronics</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>10-02-2023</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Successful</td>
                            </tr>

                            <tr>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>PoIakv</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>JwxNqi</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Water Bottle</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Sporting Goods</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>17-07-2020</td>
                                <td className='p-3 text-sm text-gray-700 whitespace-nowrap'>Refunded</td>
                            </tr>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    )
}