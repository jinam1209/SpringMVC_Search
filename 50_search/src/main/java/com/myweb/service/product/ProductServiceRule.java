package com.myweb.service.product;

import java.util.List;

import com.myweb.domain.ProductVO;

public interface ProductServiceRule {
	public int register(ProductVO pvo);
	public List<ProductVO> getList();
	public ProductVO detail(int pno);
	public int modify(ProductVO pvo);
	public int remove(int pno);
	public int getCurrPno();
}
