class Ii < Formula
  desc "Minimalist IRC client"
  homepage "https://tools.suckless.org/ii/"
  url "https://dl.suckless.org/tools/ii-1.9.tar.gz"
  sha256 "850cb323b583d261b51bda9993ee733334352a8e6ca1e2f02b57c154bf568c17"
  license "MIT"
  head "https://git.suckless.org/ii", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?ii[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ii"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "69ff5c66b7328efc392744cf377159b29720516360b0e08ced0b52f5f9a13031"
  end

  def install
    # macOS already provides strlcpy
    if OS.mac?
      inreplace "config.mk" do |s|
        s.gsub! "= -DNEED_STRLCPY -Os", "= -Os"
        s.gsub! "= strlcpy.o", "="
      end
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    port = free_port
    output = shell_output("#{bin}/ii -s localhost -p #{port} 2>&1", 1)
    assert_match "#{bin}/ii: could not connect to localhost:#{port}:", output.chomp
  end
end
