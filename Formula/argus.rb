class Argus < Formula
  desc "Audit Record Generation and Utilization System server"
  homepage "https://qosient.com/argus/"
  url "https://qosient.com/argus/src/argus-3.0.8.2.tar.gz"
  sha256 "ca4e3bd5b9d4a8ff7c01cc96d1bffd46dbd6321237ec94c52f8badd51032eeff"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://qosient.com/argus/src/"
    regex(/href=.*?argus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/argus"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fe6bcae9f3f6cf1375adfd926c23fb44ae3870e30b7639ed223f3ceff5686e09"
  end

  uses_from_macos "libpcap"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Pages", shell_output("#{bin}/argus-vmstat")
  end
end
