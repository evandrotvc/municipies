import { isValid as isValidCpf } from "@fnando/cpf";

export function cpf(value) {
  return !value || isValidCpf(value);
}

export function required(value) {
  return !!value;
}

export function email(value) {
  return /.+@.+\..+/.test(value);
}

export function charsEquals(value, length) {
  return value.length === length;
}