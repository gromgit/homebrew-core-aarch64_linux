class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v0.38.tar.gz"
  sha256 "565d52331b40793f038a2725fcc3ee53539d9ef287d582b7c305789cb1d503eb"
  license "Apache-2.0"
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03bac92a88319ff21d807b0d7438284b299262003b592987b38dda5a49389e48" => :catalina
    sha256 "927a6beeb623f29806e592eed6e2e3ee99861bc946bc24d5fd711dab50c29d15" => :mojave
    sha256 "4c5956feecd0b017e5165a4602d3d42ef4403141f35280fd1e4a0bc2369b69ea" => :high_sierra
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
