class Ripmime < Formula
  desc "Extract attachments out of MIME encoded email packages"
  homepage "https://pldaniels.com/ripmime/"
  url "https://pldaniels.com/ripmime/ripmime-1.4.0.10.tar.gz"
  sha256 "896115488a7b7cad3b80f2718695b0c7b7c89fc0d456b09125c37f5a5734406a"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?ripmime[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ripmime"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2eeb8f9bdfcce4d2aa7f174ed8eadbf7aeeaec9f7a6736994b1919fc3f5f0a13"
  end

  def install
    args = %W[
      CFLAGS=#{ENV.cflags}
    ]
    args << "LIBS=-liconv" if OS.mac?
    system "make", *args
    bin.install "ripmime"
    man1.install "ripmime.1"
  end
end
