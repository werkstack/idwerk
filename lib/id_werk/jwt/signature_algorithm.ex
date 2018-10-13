defmodule IdWerk.JWT.SignatureAlgorithm do
  alias IdWerk.OpenSSL

  def jwk do
    with config when not is_nil(config) <- config(),
         source when not is_nil(source) <- config[:source],
         %{} = jwk <- load_private_key_pem(config[:private_key], source) do
      jwk
    end
  end

  def public_key_fingerprint(jwk) do
    jwk.kty
    |> elem(1)
    |> OpenSSL.public_key_fingerprint()
  end

  def algorithm(jwk) do
    jwk.kty
    |> elem(1)
    |> elem(0)
    |> case do
      :ECPrivateKey -> "ES256"
      :RSAPrivateKey -> "RS256"
      alg -> throw({:unknown, alg})
    end
  end

  defp config do
    Application.get_env(:id_werk, IdWerk.JWT.SignatureAlgorithm)
  end

  defp load_private_key_pem(private_key_str, :string) do
    JOSE.JWK.from_pem(private_key_str)
  end

  defp load_private_key_pem(private_key_file, :file) do
    JOSE.JWK.from_pem_file(private_key_file)
  end
end
