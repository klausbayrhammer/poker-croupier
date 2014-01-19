/**
 * Autogenerated by Thrift Compiler (0.9.1)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Thrift;
using Thrift.Collections;
using System.Runtime.Serialization;
using Thrift.Protocol;
using Thrift.Transport;

namespace API
{

  #if !SILVERLIGHT
  [Serializable]
  #endif
  public partial class Card : TBase
  {
    private short _value;
    private Suit _suit;
    private string _name;

    public short Value
    {
      get
      {
        return _value;
      }
      set
      {
        __isset.value = true;
        this._value = value;
      }
    }

    /// <summary>
    /// 
    /// <seealso cref="Suit"/>
    /// </summary>
    public Suit Suit
    {
      get
      {
        return _suit;
      }
      set
      {
        __isset.suit = true;
        this._suit = value;
      }
    }

    public string Name
    {
      get
      {
        return _name;
      }
      set
      {
        __isset.name = true;
        this._name = value;
      }
    }


    public Isset __isset;
    #if !SILVERLIGHT
    [Serializable]
    #endif
    public struct Isset {
      public bool value;
      public bool suit;
      public bool name;
    }

    public Card() {
    }

    public void Read (TProtocol iprot)
    {
      TField field;
      iprot.ReadStructBegin();
      while (true)
      {
        field = iprot.ReadFieldBegin();
        if (field.Type == TType.Stop) { 
          break;
        }
        switch (field.ID)
        {
          case 1:
            if (field.Type == TType.I16) {
              Value = iprot.ReadI16();
            } else { 
              TProtocolUtil.Skip(iprot, field.Type);
            }
            break;
          case 2:
            if (field.Type == TType.I32) {
              Suit = (Suit)iprot.ReadI32();
            } else { 
              TProtocolUtil.Skip(iprot, field.Type);
            }
            break;
          case 3:
            if (field.Type == TType.String) {
              Name = iprot.ReadString();
            } else { 
              TProtocolUtil.Skip(iprot, field.Type);
            }
            break;
          default: 
            TProtocolUtil.Skip(iprot, field.Type);
            break;
        }
        iprot.ReadFieldEnd();
      }
      iprot.ReadStructEnd();
    }

    public void Write(TProtocol oprot) {
      TStruct struc = new TStruct("Card");
      oprot.WriteStructBegin(struc);
      TField field = new TField();
      if (__isset.value) {
        field.Name = "value";
        field.Type = TType.I16;
        field.ID = 1;
        oprot.WriteFieldBegin(field);
        oprot.WriteI16(Value);
        oprot.WriteFieldEnd();
      }
      if (__isset.suit) {
        field.Name = "suit";
        field.Type = TType.I32;
        field.ID = 2;
        oprot.WriteFieldBegin(field);
        oprot.WriteI32((int)Suit);
        oprot.WriteFieldEnd();
      }
      if (Name != null && __isset.name) {
        field.Name = "name";
        field.Type = TType.String;
        field.ID = 3;
        oprot.WriteFieldBegin(field);
        oprot.WriteString(Name);
        oprot.WriteFieldEnd();
      }
      oprot.WriteFieldStop();
      oprot.WriteStructEnd();
    }

    public override string ToString() {
      StringBuilder sb = new StringBuilder("Card(");
      sb.Append("Value: ");
      sb.Append(Value);
      sb.Append(",Suit: ");
      sb.Append(Suit);
      sb.Append(",Name: ");
      sb.Append(Name);
      sb.Append(")");
      return sb.ToString();
    }

  }

}
