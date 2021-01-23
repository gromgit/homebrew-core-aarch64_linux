class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.13.1.tar.gz"
  sha256 "d71b48ba6834b62ae5f52b7f50cd768af5a483283c0deed043ff4c6dde3f2344"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e075378fb2aa6fdea9ce52823919d63cf4a0cf6dbe246d56a49f7fd775f288e7" => :big_sur
    sha256 "1954acfa51b066a3a86c2a72aacd96ecc162ff98f5d476b9aa6d14a5a6fdebf1" => :catalina
    sha256 "17364947eba43c48ecece909a3442a7044df6f0b02a5f4c0a1f707865361c447" => :mojave
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd "src/github.com/Workiva/frugal" do
      system "glide", "install"
      system "go", "build", "-o", bin/"frugal"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
