# frozen_string_literal: true
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:yahoo_auth] = OmniAuth::AuthHash.new({
                                                                      provider: 'yahoo_auth',
                                                                      info: {
                                                                        nickname: 'Test',
                                                                        email: 'test@yahoo.com',
                                                                        first_name: 'Stanley',
                                                                        last_name: 'Test Spectre',
                                                                        image: 'https://s.yimg.com/wm/modern/images/default_user_profile_pic_192.png',
                                                                        uid: nil
                                                                      },
                                                                      credentials: {
                                                                        token: "r_9gMWibuBsj3nbVGkt7gcpKquFRGPzJ8qfyZMQQmPssbpIpkp6ChHwKNfD1UyYlNfvAw6DZWzkkqBmwm.vU3ccj89uTKZaJf5wXUdFYRfYu8Wt5zVBYFFM6fl79QshRkUGcOQ3J_vHLCh9Rd3UqJUZUvDMXuEsUFnqHwRlOkXtMuzm3ZC6Th1vUomtBUHjon.tBeIarYrzc_UX5q_ol1V7mX_yOyrw59Hm4Y35gTZgZ4labvEggYHyC1jtF2whN.BAmy0dg66jqcF_cTt68gVMhI38nmr4BsgaJbH1lDZ.tPiX9eDpXKvBZeMwFPWlOxnK7uX.4DdB_poYbfdkSSumAGkjo_UJc9jvErK5keVZyTGoId_W8PAEtLx3SEGrG4B78kuDakNf7gtKBSGFkhzoCsBqnxvwdl5Tb1li_gX.rKetO.bAlm7FdOLthjFQWQS2V8s3kXC3VIYr0tZj63Av1MZo_7LJGYFiyMRAmgPyqwiTSYTn.5CAFSJtGEol2PtgcPNhOmsjNdPEYrRUTy___sCljR6h.3At7tT52URoqizZv_yHS.FEbW77T7zIFO55rO9MajC7.0U.akS0Z8CVfTbzKXKnUFXSmdx_B46oftH4neS0z4Ke.EaZKPo5YUt3YPdFWoYUAdenW552vc9xFyggpQyw3PRpSa3qv9ZyLIEwKYZy3e8PkdHTntrsqpgVqj6ZTPqf84dpIDgKlOwR2JGR5_rmPEzI2TMcgR9cwkXcmx19O4WsQh3OD0ZVEsyOaEag0rQRX7bLbX3b6YkSPlRJ5KNsjw7Z6A3XwE_pmj6UWiNrFc_wHUOqAdY10wGBrYddsd65Q4PC2Jt4vn6LxT3yvTEtyk0Q8yGbE0X128Ca.tg3XB7FPjK_wWqUDl3d9cCyd17tGp1D2rOen9o0l39_FSJkY4iI4lPXYGd4o_pBdhwXr99jWF2tmFkcMxXlHjgsdhR0aWUkqb0ld9qV2_bTX1w2B1T_eKcJhIEVICuxhXNYglZRpslKuiyZpe8vy_u9WBf28Z0WhYRPeKn_1yKD7u0tBgTYlQRg-",
                                                                        refresh_token: "AIli2mG5W3C.4FZdv77yDkxML2DaEgcSe7s6HlPgj7bbxLap4YNrk5TQ.rn2G.DB",
                                                                        expires_at: "1643340133",
                                                                        expires: true
                                                                      },
                                                                      extra: {
                                                                        sub: '',
                                                                        name: '',
                                                                        middle_name: '',
                                                                        nickname: '',
                                                                        gender: 'M',
                                                                        language: 'en-IN',
                                                                        website: '',
                                                                        birth_date: '',
                                                                        zone_info: '',
                                                                        updated_at: '',
                                                                        email_verified: true,
                                                                        address: '',
                                                                        phone_number: '',
                                                                        phone_number_verified: false
                                                                      }
                                                                    })

