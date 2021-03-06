/* Automatically generated nanopb header */
/* Generated by nanopb-0.4.4 */

#ifndef PB_COMMANDS_PB_H_INCLUDED
#define PB_COMMANDS_PB_H_INCLUDED
#include <pb.h>

#if PB_PROTO_HEADER_VERSION != 40
#error Regenerate this file with the current version of nanopb generator.
#endif

/* Enum definitions */
typedef enum _House {
    House_UNKNOWN_HOUSE = 0,
    House_VICTORIA_STATION = 1,
    House_TEA_SHOPPE = 2,
    House_SPICE_MARKET = 3,
    House_MARIONETTES = 4,
    House_FELLOWSHIP_PORTERS = 5,
    House_FEZZIWIG_WAREHOUSE = 6,
    House_FEZZIWIG_WAREHOUSE_2 = 7,
    House_CROOKED_FENCE_COTTAGE = 8,
    House_BUTCHER = 9,
    House_CUROSITY_SHOP = 10,
    House_BAKERY = 11
} House;

/* Struct definitions */
typedef struct _Config {
    pb_callback_t house_pins;
} Config;

typedef struct _ChangeLight {
    House house;
    uint32_t white;
    uint32_t red;
} ChangeLight;

typedef struct _Config_HousePinsEntry {
    uint32_t key;
    House value;
} Config_HousePinsEntry;


/* Helper constants for enums */
#define _House_MIN House_UNKNOWN_HOUSE
#define _House_MAX House_BAKERY
#define _House_ARRAYSIZE ((House)(House_BAKERY+1))


#ifdef __cplusplus
extern "C" {
#endif

/* Initializer values for message structs */
#define Config_init_default                      {{{NULL}, NULL}}
#define Config_HousePinsEntry_init_default       {0, _House_MIN}
#define ChangeLight_init_default                 {_House_MIN, 0, 0}
#define Config_init_zero                         {{{NULL}, NULL}}
#define Config_HousePinsEntry_init_zero          {0, _House_MIN}
#define ChangeLight_init_zero                    {_House_MIN, 0, 0}

/* Field tags (for use in manual encoding/decoding) */
#define Config_house_pins_tag                    1
#define ChangeLight_house_tag                    1
#define ChangeLight_white_tag                    2
#define ChangeLight_red_tag                      3
#define Config_HousePinsEntry_key_tag            1
#define Config_HousePinsEntry_value_tag          2

/* Struct field encoding specification for nanopb */
#define Config_FIELDLIST(X, a) \
X(a, CALLBACK, REPEATED, MESSAGE,  house_pins,        1)
#define Config_CALLBACK pb_default_field_callback
#define Config_DEFAULT NULL
#define Config_house_pins_MSGTYPE Config_HousePinsEntry

#define Config_HousePinsEntry_FIELDLIST(X, a) \
X(a, STATIC,   SINGULAR, UINT32,   key,               1) \
X(a, STATIC,   SINGULAR, UENUM,    value,             2)
#define Config_HousePinsEntry_CALLBACK NULL
#define Config_HousePinsEntry_DEFAULT NULL

#define ChangeLight_FIELDLIST(X, a) \
X(a, STATIC,   SINGULAR, UENUM,    house,             1) \
X(a, STATIC,   SINGULAR, UINT32,   white,             2) \
X(a, STATIC,   SINGULAR, UINT32,   red,               3)
#define ChangeLight_CALLBACK NULL
#define ChangeLight_DEFAULT NULL

extern const pb_msgdesc_t Config_msg;
extern const pb_msgdesc_t Config_HousePinsEntry_msg;
extern const pb_msgdesc_t ChangeLight_msg;

/* Defines for backwards compatibility with code written before nanopb-0.4.0 */
#define Config_fields &Config_msg
#define Config_HousePinsEntry_fields &Config_HousePinsEntry_msg
#define ChangeLight_fields &ChangeLight_msg

/* Maximum encoded size of messages (where known) */
/* Config_size depends on runtime parameters */
#define Config_HousePinsEntry_size               8
#define ChangeLight_size                         14

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif
