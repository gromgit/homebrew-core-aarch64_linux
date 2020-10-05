class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v038.1.tar.gz"
  sha256 "0d2f88170305d54b143410276ff84da98e3ae9c36abe52430d9c2b510fa77884"
  license "Apache-2.0"
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84629567f4b45c48075377da17b3d42fc2bb69d0efab99ba9206e8b8c6dec288" => :catalina
    sha256 "d5b86454772f6d417a926e938f821ff8a06eec689d982ed2a3673e9079fbec84" => :mojave
    sha256 "f247ee0a9b64cd1febf86830f6aeed5492c09b651e3459973f87d532762aff61" => :high_sierra
  end

  depends_on "python@3.8"

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
