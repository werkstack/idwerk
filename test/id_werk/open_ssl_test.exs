defmodule IdWerk.OpenSSLTest do
  use ExUnit.Case, async: true

  alias IdWerk.OpenSSL

  describe "rsa" do
    @rsa_pem """
    -----BEGIN PRIVATE KEY-----
    MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCwGBWXa0Z6AsQb
    7yiI4FDpR/peXzuUnAfB/UOTSj1kxBekX5rLC9B2FHe59FNV6UJr46BI7ChyRFbs
    teHrrpSCte6OiylMoJECHsC+R8qpXP0EsxiIMpKjmiMm6NNG1dXDichVz2feDQtb
    cxVo3nHx9JL/jZuae+bsbDZ9UkBdI3ZnYco8KoG1zXymR20tlPAIMYyOVZ8xOMb1
    ixwtiZkROHzbMcIKNTEKPCD8wx1DAZ+LRR4lZ+UyPoTSVettLHjzZW4T9QJy6ghP
    WrJzi6twWKup0ftWoHceXvS8BQYx8A6if0XUr745Kt6+QdU3FOAJ60nPcpCP/h2t
    4rTex8HdAgMBAAECggEAPOIm3PJ/LII2Ub4vkpuT/gQf4W8lx2znFcA+E/fQID3Y
    OsG/YEKWca0D9Cwwf/ylNW4/JddY6KEOOMtt8DGtMUA72dbtkYvWdxgw5dkmjcYT
    yQMvETADGUOascJAAja+sNu7g0exjsmNyrGQjnCSjuhTxr2sNg5uugF0GYJNtKWR
    57P5OLvlkcRADLnvOGILUhiSGpWfS42w090yNxuHZaVosUnPdcyH4PXIkptr/vrb
    GkrGyWz6717pAkXZdMdAjiQ1/8NcoPG16bhCndW83VVxZUfKLMWCGxaB6PhThtGO
    NuhZCxzeV4BxIdToweZSYZF30A0T9fHEsUVkKvk1VQKBgQDmI6tICcf6pWDrBVAG
    l5lGgxqRsqds+rP1TZmyMqVKVI9azxeTUY7jngnbhStE6ymtfYWfDKE5MNTpV9bs
    cmYTcpDz781UwMG5dTKmRUKi5D6TqJsg4Q1XfHCCXVIBaA4hiHCSDr3KcuPC/hpB
    djMjqgP3niz935Fyt3ipejlWiwKBgQDD4bdJ+0iSoxWtsXBhMXN1JBwHID1MFVB4
    p+irIb+SgAEVaIZohqUhjvmppD4fEE6BUjnoo8zB5Z8QnQv5ica7ToAUdcdNeq5E
    8GOJ6hwJftiRm4rCDKSdOZluBq+IiEB6bwukG+xmWqIpofdOQxEpUmd968G8uoFb
    w3iLzRG+NwKBgAlecl6gZ0/A480tjjB2g3rnY3GDAGXjXughnJwwi6IXBy7/N0p8
    C4Egse4J4dUQbcXuUj5DWVzmrARD2zANCDLKezQzEvzcTAasyr8SGsBe4l1Ig+g2
    wUBKhJoKCoicH9clos+PYhKX0sXhalg346UUCs1N1y8OpvEwnuznWOY5AoGBAJhR
    owfCgVKVwrvIaQ0LOS70H19jMIdDY8oPN5wrqB6xryYIm8wYN7x6w6Wo9C2Prpxd
    Zm6DQSvd9O0kUjV/b6wjhPFkDNEw/ubYz25lP9waaSoA+8udrTwdmDO4uzK+UPVj
    +Hdqx09oVwVszzRqbqPlUljWxVaO6RyESe7cTlnNAoGABRlnRZP20awAyeksosfO
    PMF7BOT5+4lC2LpN4+b8WNL8aq2Z2Kv6uuk+ulL4d/EyOHKSYA8vwSd4KufvS/xO
    hSwg/6tpagobyLsfnBzt34uaTfIPZ1bojIunCgKIXPUmDwyo7gCnTgWqveay5z13
    zTe1+5Rmd08VcJpsCGFqd1U=
    -----END PRIVATE KEY-----
    """

    test "parse rsa private key" do
      assert {:ok, pem_entry} = OpenSSL.from_pem(@rsa_pem)
      assert elem(pem_entry, 0) == :RSAPrivateKey
      assert elem(pem_entry, 1) == :"two-prime"
    end

    test "extract rsa public key" do
      assert {:ok, pem_entry} = OpenSSL.from_pem(@rsa_pem)

      assert {:RSAPublicKey, _, _} = OpenSSL.public_key(pem_entry)
    end

    test "extract rsa public key to der encoding" do
      assert {:ok, pem_entry} = OpenSSL.from_pem(@rsa_pem)

      assert public_key = OpenSSL.public_key(pem_entry)
      assert public_key_pem = OpenSSL.public_key_to_pem(public_key)

      assert Base.encode64(public_key_pem) =~
               "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsBgVl2tGegLEG+8oiOBQ"
    end
  end

  describe "ec - secp256r1" do
    @ec_pem """
    -----BEGIN EC PRIVATE KEY-----
    MHcCAQEEIGrAIJcVpJSsdCS5YO0NfA8mmJeBWt2fdzbMPxvNNml2oAoGCCqGSM49
    AwEHoUQDQgAELfKeoQQGPM4/4wxh0WOgP7tXoJrPTrSQSIMKI6pAYU68ZP3ONI1I
    VW83OtgmEVPLt+kxIHooeHVxz90jKeuaVw==
    -----END EC PRIVATE KEY-----
    """
  end

  test "parses private key" do
    assert {:ok, pem_entry} = OpenSSL.from_pem(@ec_pem)
    assert elem(pem_entry, 0) == :ECPrivateKey
  end

  test "extracts public key" do
    assert {:ok, pem_entry} = OpenSSL.from_pem(@ec_pem)

    assert {{:ECPoint, _}, {:namedCurve, _}} = OpenSSL.public_key(pem_entry)
  end

  test "extract public key to der encoding" do
    assert {:ok, pem_entry} = OpenSSL.from_pem(@ec_pem)

    assert public_key = OpenSSL.public_key(pem_entry)
    assert public_key_pem = OpenSSL.public_key_to_pem(public_key)

    assert Base.encode64(public_key_pem) =~ "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQg"
  end
end
