import asyncio


async def coro1():
    v1 = await coro2()
    return v1


async def coro2():
    yield 3
    yield 4


async def main():
    print(await coro1())


if __name__ == '__main__':
    asyncio.run(main())
