class TykConfig(KeycloakOidConfig):
    """
    Configuration to use when forwarding requests through the API gateway.
    This also requires that keycloak config is being used and is set up properly.

    To start a dev flask server using this config add in launch option, -c TykConfig
    """

    TYK_ENABLED = True
    TYK_SERVER = 'http://tyk-gateway:8080'
    TYK_LISTEN_PATH = '/candig-dev'

    # Keycloak settings with redirection through tyk
    KC_REALM = 'CanDIG'
    KC_SERVER = 'http://keycloak:8081'
    KC_SCOPE = 'openid+email'
    KC_RTYPE = 'code'
    KC_CLIENT_ID = 'ga4gh'
    KC_RMODE = 'form_post'
    KC_REDIRECT = TYK_SERVER + TYK_LISTEN_PATH + '/login_oidc'
    KC_LOGIN_REDIRECT = '/auth/realms/{0}/protocol/openid-connect/auth?scope={1}&response_type={2}&client_id={3}&response_mode={4}&redirect_uri={5}'.format(
        KC_REALM, KC_SCOPE, KC_RTYPE, KC_CLIENT_ID, KC_RMODE, KC_REDIRECT
    )



