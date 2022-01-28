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
                                                                        token: 'wxr7h0CbuBsJhS_xd8igMeFocidQ3TZMyxKh86PNSR1CX9IZnvMLeYllNLB5.HKDt_Xwszf4FfQtwCrqdELXBhL1.kQMz_VWF6yKYm_c86Ip_7WCxbiU5PZlIF7tvn9zbLGPhQ3IJoxhTIIL_EU9TAGVQQjEAZEK7reMCQuiJN4zAQXbT94Ne1wnO.oJVOryzNmupET.M7jbNXEV3TBbfF0TA93uQ7hxRiF4JFPMZu_N97q3QAUzLppXN.6k2NgO8EVkkoFkfvm5FbHbUBcVgUfSF6zF1xm1yEN2b4EdN00Jvx6xJsCJ8OkusNO36.2oQ27eCeBoZ8we0eNGHcNG243CPgRnmzB018wVcEir_5BWbTW9W_nRIfjn.V04MB_A2swUYEwN6vVy92isj0IFik.rNpk2RGywOWPPW44HgiWoR2EQDovmR47.ifSID6.0bqq1z7uzjBWtvlMM8zIdWIF7MC2zwT3mhj7qgiDqYiLsh9UhaTmSbfgSRk4rnrsuZlQDtjzTi3d3uuQEFkOe7mdiw9HBl58by3i3a_wcpyuLnjaOJ8o7aySgIwGRjwbzpu02VAE0x3FLjreSRDEqQ9F6qr0vH8mpCBmlLfMgwXR2VNuz_nuTDdN4AEx4ghYGMQOaI4TX0zG5KCNPXkhOl2ufTZkhr4lh9Rv6p0BHKzSnchebOlI7T7gvc0XeF74pLAiUquUF1mnjdpycSGApALrk0Z8cYZCMtim.mNvbi3IuwhFUUn5puAP2fUIFlMtxz6Bc2LA9.1HWAu9HAU6.SQ0q0W4xbIvH0wGmbrVFj2SKIw.4Pb5ghRLAIir9nTpHEQXabS6ocE1YnSoc5dZBXptcdiDV45W868sZgjB.ANBUxP_lGm622z.nqBNnQ2Xo8SYW9kE_tp6vUCE4GrERSd3n9.9gJqDyudzluUc1w25mHlVOMnCRUZ8KXkmoDWACsBlLUEPHCT3ouv8yGUgH6TH61stNasnslUi.JFNLfw3JRw_zborGunEx_ABEL8cFuNgS6fmO8egkS_ixsarRTO32Qy7GytuRIl32bf0-',
                                                                        refresh_token: 'AIli2mG5W3C.4FZdv77yDkxML2DaEgcSe7s6HlPgj7bbxLap4YNrk5TQ.rn2G.DB',
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

