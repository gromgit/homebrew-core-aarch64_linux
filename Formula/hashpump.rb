class Hashpump < Formula
  desc "Tool to exploit hash length extension attack"
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"
  license "MIT"
  revision 6

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/hashpump"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4a0375facffc5a10970a2ca487f8cf6eca75a9e299cd823f940c14a4e71ce23f"
  end

  depends_on "openssl@1.1"
  depends_on "python@3.10"

  # Remove on next release
  patch do
    url "https://github.com/bwall/HashPump/commit/1d76a269d18319ea3cc9123901ea8cf240f7cc34.patch?full_index=1"
    sha256 "ffc978cbc07521796c0738df77a3e40d79de0875156f9440ef63eca06b2e2779"
  end

  def install
    bin.mkpath
    system "make", "INSTALLLOCATION=#{bin}",
                   "CXX=#{ENV.cxx}",
                   "install"

    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    output = `#{bin}/hashpump -s '6d5f807e23db210bc254a28be2d6759a0f5f5d99' \ \
      -d 'count=10&lat=37.351&user_id=1&long=-119.827&waffle=eggo' \ \
      -a '&waffle=liege' -k 14`
    assert_match "0e41270260895979317fff3898ab85668953aaa2", output
    assert_match "&waffle=liege", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
