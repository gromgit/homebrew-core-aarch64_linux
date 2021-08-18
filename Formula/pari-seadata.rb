class PariSeadata < Formula
  desc "Modular polynomial data for PARI/GP"
  homepage "https://pari.math.u-bordeaux.fr/packages.html"
  url "https://pari.math.u-bordeaux.fr/pub/pari/packages/seadata.tgz"
  # Refer to http://pari.math.u-bordeaux.fr/packages.html#packages for most recent package date
  version "20090618"
  sha256 "c9282a525ea3f92c1f9c6c69e37ac5a87b48fb9ccd943cfd7c881a3851195833"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e1310a89e74bc49b8fb00213aa9210b7e2fa89c6529a23771b185a63c3b1a668"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1310a89e74bc49b8fb00213aa9210b7e2fa89c6529a23771b185a63c3b1a668"
    sha256 cellar: :any_skip_relocation, catalina:      "e1310a89e74bc49b8fb00213aa9210b7e2fa89c6529a23771b185a63c3b1a668"
    sha256 cellar: :any_skip_relocation, mojave:        "e1310a89e74bc49b8fb00213aa9210b7e2fa89c6529a23771b185a63c3b1a668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b521d8b719cf49b0b8a4a1d81d4819e7789af3f3a141bfda7a7f7b19fa7a8ee4"
  end

  depends_on "pari"

  def install
    (share/"pari/seadata").install gzip(*Dir["#{buildpath}/seadata/sea*"])
    doc.install "seadata/README"
  end

  test do
    expected_output = "[x^4 + 36*x^3 + 270*x^2 + (-y + 756)*x + 729, 0]"
    output = pipe_output(Formula["pari"].opt_bin/"gp -q", "ellmodulareqn(3)").chomp
    assert_equal expected_output, output
  end
end
