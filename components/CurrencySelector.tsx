import React, { useState } from 'react';
import { 
  View, 
  Text, 
  StyleSheet, 
  TouchableOpacity, 
  Modal, 
  FlatList,
  TextInput
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';

type Currency = {
  code: string;
  symbol: string;
  name: string;
};

type CurrencySelectorProps = {
  currencies: Currency[];
  selectedCurrency: Currency;
  onSelect: (currency: Currency) => void;
};

const CurrencySelector: React.FC<CurrencySelectorProps> = ({ 
  currencies, 
  selectedCurrency, 
  onSelect 
}) => {
  const [modalVisible, setModalVisible] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');

  const filteredCurrencies = searchQuery 
    ? currencies.filter(curr => 
        curr.name.toLowerCase().includes(searchQuery.toLowerCase()) || 
        curr.code.toLowerCase().includes(searchQuery.toLowerCase())
      )
    : currencies;

  const handleSelect = (currency: Currency) => {
    onSelect(currency);
    setModalVisible(false);
    setSearchQuery('');
  };

  return (
    <>
      <TouchableOpacity 
        style={styles.selector}
        onPress={() => setModalVisible(true)}
      >
        <View style={styles.currencyInfo}>
          <Text style={styles.currencyCode}>{selectedCurrency.code}</Text>
          <Ionicons name="chevron-down" size={16} color="#777" />
        </View>
      </TouchableOpacity>

      <Modal
        visible={modalVisible}
        animationType="slide"
        transparent={true}
        onRequestClose={() => setModalVisible(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <Text style={styles.modalTitle}>Select Currency</Text>
              <TouchableOpacity onPress={() => setModalVisible(false)}>
                <Ionicons name="close" size={24} color="#333" />
              </TouchableOpacity>
            </View>

            <View style={styles.searchContainer}>
              <Ionicons name="search" size={20} color="#999" style={styles.searchIcon} />
              <TextInput 
                style={styles.searchInput}
                placeholder="Search currencies"
                value={searchQuery}
                onChangeText={setSearchQuery}
                placeholderTextColor="#999"
              />
            </View>

            <FlatList
              data={filteredCurrencies}
              keyExtractor={(item) => item.code}
              style={styles.currencyList}
              renderItem={({ item }) => (
                <TouchableOpacity 
                  style={[
                    styles.currencyItem,
                    selectedCurrency.code === item.code && styles.selectedItem
                  ]}
                  onPress={() => handleSelect(item)}
                >
                  <Text style={styles.currencySymbol}>{item.symbol}</Text>
                  <View style={styles.currencyDetails}>
                    <Text style={styles.currencyItemCode}>{item.code}</Text>
                    <Text style={styles.currencyName}>{item.name}</Text>
                  </View>
                  {selectedCurrency.code === item.code && (
                    <Ionicons name="checkmark" size={22} color="#0066CC" />
                  )}
                </TouchableOpacity>
              )}
            />
          </View>
        </View>
      </Modal>
    </>
  );
};

const styles = StyleSheet.create({
  selector: {
    paddingHorizontal: 16,
    paddingVertical: 16,
    flexDirection: 'row',
    alignItems: 'center',
    borderRightWidth: 1,
    borderRightColor: '#DDD',
  },
  currencyInfo: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  currencyCode: {
    fontSize: 16,
    fontWeight: '500',
    marginRight: 4,
    color: '#333',
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'flex-end',
  },
  modalContent: {
    backgroundColor: '#FFFFFF',
    borderTopLeftRadius: 16,
    borderTopRightRadius: 16,
    paddingTop: 16,
    maxHeight: '80%',
  },
  modalHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingBottom: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#EEE',
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#333',
  },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#F5F5F5',
    margin: 16,
    borderRadius: 8,
    paddingHorizontal: 10,
  },
  searchIcon: {
    marginRight: 8,
  },
  searchInput: {
    flex: 1,
    paddingVertical: 12,
    fontSize: 16,
    color: '#333',
  },
  currencyList: {
    flexGrow: 0,
  },
  currencyItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 16,
    paddingHorizontal: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#F0F0F0',
  },
  selectedItem: {
    backgroundColor: '#F0F7FF',
  },
  currencySymbol: {
    fontSize: 18,
    fontWeight: '500',
    marginRight: 12,
    width: 24,
    textAlign: 'center',
    color: '#555',
  },
  currencyDetails: {
    flex: 1,
  },
  currencyItemCode: {
    fontSize: 16,
    fontWeight: '500',
    color: '#333',
  },
  currencyName: {
    fontSize: 14,
    color: '#777',
  },
});

export default CurrencySelector;