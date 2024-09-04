class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://github.com/tukaani-project/xz/releases/download/v5.6.2/xz-5.6.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lzmautils/xz-5.6.2.tar.gz"
  mirror "https://archive.org/download/xz-5.6.2.tar/xz-5.6.2.tar.gz"
  mirror "http://archive.org/download/xz-5.6.2.tar/xz-5.6.2.tar.gz"
  sha256 "8bfd20c0e1d86f0402f2497cfa71c6ab62d4cd35fd704276e3140bfb71414519"
  license all_of: [
    "0BSD",
    "GPL-2.0-or-later",
  ]
  version_scheme 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xz-5.6.2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "11e69230aeb03ac236e5fe9420ea2d9ca1fe02c6229e0bd4da7b29ef295295dd"
  end

  deny_network_access! [:build, :postinstall]

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-nls"
    system "make", "check"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.xz
    system bin/"xz", path
    refute_predicate path, :exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read

    # Check that http mirror works
    xz_tar = testpath/"xz.tar.gz"
    stable.mirrors.each do |mirror|
      next if mirror.start_with?("https")

      xz_tar.unlink if xz_tar.exist?
      system "curl", "--location", mirror, "--output", xz_tar
      assert_equal stable.checksum.hexdigest, xz_tar.sha256
    end
  end
end
