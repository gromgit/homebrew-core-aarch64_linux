class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://files.pythonhosted.org/packages/75/19/f519ef8aa2f379935a44212c5744e2b3a46173bf04e0110fb7f4af4028c9/scour-0.38.2.tar.gz"
  sha256 "6881ec26660c130c5ecd996ac6f6b03939dd574198f50773f2508b81a68e0daf"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/scour-project/scour.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8a91c497d4200b82a6e24f3104b5fd4d7d6cba4d8abb4a9c500a903ad69c5e37" => :big_sur
    sha256 "bf48e8efd48691881109cee3441291fe9216ef200c6592a10f968a23d4525017" => :catalina
    sha256 "83b18dcaf7f38451261de53be10328a6dc2ebc570d1e1d5840961c89a79748f3" => :mojave
  end

  depends_on "python@3.9"

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
