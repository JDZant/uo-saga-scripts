function hex_to_dec(hex_str)
  -- Removes "0x" prefix if present
  hex_str = hex_str:gsub("^0x", "")
  return tonumber(hex_str, 16)
end

function dec_to_hex(dec_num)
  return string.format("%x", dec_num)
end