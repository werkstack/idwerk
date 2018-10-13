defmodule IdWerk.JWT do
  alias IdWerk.JWT.SignatureAlgorithm
  alias JOSE.JWS

  def create_auth_token(user, service, access, opts \\ []) do
    expire_in = opts[:expire_in] || [minutes: 5]

    now = DateTime.utc_now()

    jwt_params = %{
      iss: "auth.docker.local",
      sub: user.id,
      aud: service.name,
      exp: DateTime.to_unix(Timex.shift(now, expire_in)),
      iat: DateTime.to_unix(now),
      jti: Base.url_encode64(:crypto.strong_rand_bytes(9)),
      nbf: DateTime.to_unix(Timex.shift(now, minutes: -5)),
      access: access
    }

    jwk = SignatureAlgorithm.jwk()

    header = %{
      "typ" => "JWT",
      "kid" => SignatureAlgorithm.public_key_fingerprint(jwk),
      "alg" => SignatureAlgorithm.algorithm(jwk)
    }

    jwk
    |> JWS.sign(Jason.encode!(jwt_params), header)
    |> JOSE.JWS.compact()
    |> elem(1)
  end
end
