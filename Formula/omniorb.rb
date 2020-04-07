class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2"
  sha256 "28c01cd0df76c1e81524ca369dc9e6e75f57dc70f30688c99c67926e4bdc7a6f"

  bottle do
    cellar :any
    sha256 "dd6f9c9ef1b96969d50b0d3ce88d93f44892a3bc79b68268fef0c4cfceed085d" => :catalina
    sha256 "e83175a98726c50971b3be9058eff3625987ad318df5a3272c4c6a19df7b401e" => :mojave
    sha256 "603cee3162a0601304361565b3ee1e23b81770a8bc273f1bacbdbef7c06a19b1" => :high_sierra
    sha256 "5d005d42b413d7cb693321eab9e5ff7dc8e39b5c731da30c4adabf15138974cf" => :sierra
  end

  depends_on "pkg-config" => :build

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
    sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
  end
end
