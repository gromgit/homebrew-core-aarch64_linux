class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3460stable.tar.gz"
  version "3.46.0"
  sha256 "6998fb8b5e20435bcbc52508a8f7c59483ca5485974ef40b0bfb31eb6f46654e"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c1410c2657755a09dac0cee084bb0939d9a98406a11d0d6a4751c16ec97de885"
    sha256 cellar: :any_skip_relocation, catalina: "7897b2f6b45f04273d649462dfa1344a0d33c5b83dcd847d2f7d906564f6885a"
    sha256 cellar: :any_skip_relocation, mojave:   "e6e05afc2964203dc1209dda3386889e5db25201548dd711cfe1ceb313eaffb1"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
