seeds = [
  %DanubianTrade.Products.Product{ name: "Guinness", description: "Great Irish Beer", image: "https://d1lqpgkqcok0l.cloudfront.net/medias/sys_master/h69/hae/9098216243230.jpg", price: 2, quantity: 100, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Purcari", description: "Best Wine Ever", image: "https://s13emagst.akamaized.net/products/36326/36325828/images/res_ab5e13dcafa795ed7331a3dc6ebeb86f.jpg", price: 40, quantity: 100, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Ipad 9", description: "Will get your inspiration going", image: "https://s13emagst.akamaized.net/products/40530/40529521/images/res_1e0c2ea72c8d4c7052ec85137524cae2.jpg", price: 2000, quantity: 20, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Banana", description: "Yummy fruity treat", image: "https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg", price: 2, quantity: 100, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Cat nip", description: "Your cat's never been higher", image: "https://s7d2.scene7.com/is/image/PetSmart/5266724", price: 50, quantity: 100, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Ergonomic keyboard", description: "You'll type like never before", image: "https://www.zdnet.com/a/img/resize/90ca071ed85a318a6fdffc6968a3a489ca44eb07/2022/02/14/473ab888-3d72-4fc7-9203-5928c3ee6389/ergo-keyboard-action-shot.jpg?width=1200&height=900&fit=crop&auto=webp", price: 2000, quantity: 100, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Ergonomic mouse", description: "If you really need it, this is the best", image: "https://www.tradeinn.com/f/13814/138141493/logitech-ergo-m575-wireless-ergonomic-mouse-2000dpi.jpg", price: 200, quantity: 100, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Course bike", description: "I am speed", image: "https://steel-vintage.com/media/catalog/product/cache/17ac0aa85a620128c87b646757083030/p/e/peugeot-course-classic-steel-bicycle-2.jpg", price: 2000, quantity: 100, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Bonk T Shirt", description: "Bonk", image: "https://ae01.alicdn.com/kf/H21b0822d50874db0b25aa6c52a5602269/Unisex-Men-Women-T-Shirt-Bonk-Meme-Doge-Funny-Artwork-Printed-Tee.jpg_Q90.jpg_.webp", price: 50, quantity: 100, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Crypto Hate Shirt", description: "For the outspoken hater", image: "https://i.etsystatic.com/31891242/r/il/4e527d/3621404006/il_570xN.3621404006_7bvp.jpg", price: 50, quantity: 100, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Linux Plushie", description: "Show off your inner geek", image: "https://www.tuxedocomputers.com/store_files/1/images/product_images/popup_images/3pluesch_tux_30cm_linux_pinguin_03.jpg", price: 20, quantity: 100, creator_id: 1 },
  %DanubianTrade.Products.Product{ name: "Principles of Philosophy", description: "Will have to read it first to prove it exists", image: "https://m.media-amazon.com/images/I/41emgycz2zL.jpg", price: 100, quantity: 100, creator_id: 1 },
]

existing = DanubianTrade.Products.Product |> DanubianTrade.Repo.all

seeds
  |> Enum.filter(fn product -> !Enum.any?(existing, fn existing_product -> product.image == existing_product.image end) end)
  |> Enum.each(fn product -> DanubianTrade.Repo.insert(product) end)
