class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://code.videolan.org/videolan/x264.git",
      revision: "baee400fa9ced6f5481a728138fed6e867b0ff7f"
  version "r3095"
  license "GPL-2.0-only"
  head "https://code.videolan.org/videolan/x264.git", branch: "master"

  # Cross-check the abbreviated commit hashes from the release filenames with
  # the latest commits in the `stable` Git branch:
  # https://code.videolan.org/videolan/x264/-/commits/stable
  livecheck do
    url "https://artifacts.videolan.org/x264/release-macos-arm64/"
    regex(%r{href=.*?x264[._-](r\d+)[._-]([\da-z]+)/?["' >]}i)
    strategy :page_match do |page, regex|
      # Match the version and abbreviated commit hash in filenames
      matches = page.scan(regex)

      # Fetch the `stable` Git branch Atom feed
      stable_page_data = Homebrew::Livecheck::Strategy.page_content("https://code.videolan.org/videolan/x264/-/commits/stable?format=atom")
      next if stable_page_data[:content].blank?

      # Extract commit hashes from the feed content
      commit_hashes = stable_page_data[:content].scan(%r{/commit/([\da-z]+)}i).flatten
      next if commit_hashes.blank?

      # Only keep versions with a matching commit hash in the `stable` branch
      matches.map do |match|
        release_hash = match[1]
        commit_in_stable = commit_hashes.any? do |commit_hash|
          commit_hash.start_with?(release_hash)
        end

        match[0] if commit_in_stable
      end
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/x264"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a2fec1014e6c4fdc20bd7c1b4be01c4a76aafdbbf5fa8a99f81465ab0885f097"
  end

  on_macos do
    depends_on "gcc" if DevelopmentTools.clang_build_version <= 902
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
  fails_with :clang do
    build 902
    cause "Stack realignment requires newer Clang"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --disable-swscale
      --disable-ffms
      --enable-shared
      --enable-static
      --enable-strip
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s.delete("r"), shell_output("#{bin}/x264 --version").lines.first
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <x264.h>

      int main()
      {
          x264_picture_t pic;
          x264_picture_init(&pic);
          x264_picture_alloc(&pic, 1, 1, 1);
          x264_picture_clean(&pic);
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-lx264", "-o", "test"
    system "./test"
  end
end
