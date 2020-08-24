class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.0.8",
      revision: "6a9eedea88d4194407f8c0a578e4458f73b7364d"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b78a1dd9611f016c24fd19bcd764031cbd7a514e156ff04b9a5b0c75d2bfe44" => :catalina
    sha256 "94cfe788bc39fb1f5042ab6ce565fbaa98568362698d6fc2441487a3a79f27e5" => :mojave
    sha256 "b074364d9806ef46e750c685f27368882185592c5cb3f825da345c05340845ed" => :high_sierra
  end

  def install
    system "make", "release"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.js").write <<~EOS
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    EOS
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
  end
end
