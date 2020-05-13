class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      :tag      => "v1.6.4",
      :revision => "4cfb3185b6c72ac4a67eaaf17f842cc1dacf27c7"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any
    sha256 "f729913676a53d457907bedf910e83ba655ec27c0c18db9532918d6552ff34aa" => :catalina
    sha256 "3d0fb7ce08e8b75c0cf90342ae2722fa9038abcf0abcbbff9921c1779d026b6b" => :mojave
    sha256 "9fafb851900debaf09ac7b3dbcd9b6e72bad4521576005a2baf7c843d9fc9d8d" => :high_sierra
  end

  depends_on "carthage" => :build
  depends_on :xcode => ["10.1", :build]

  def install
    # Working around build issues in dependencies
    # - Prevent warnings from causing build failures
    # - Prevent linker errors by telling all lib builds to use max size install names
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      GCC_TREAT_WARNINGS_AS_ERRORS = NO
      OTHER_LDFLAGS = -headerpad_max_install_names
    EOS
    ENV["XCODE_XCCONFIG_FILE"] = xcconfig

    # Only build necessary dependencies (Commandant, Result)
    system "carthage", "bootstrap", "--platform", "macOS", "Commandant", "Result"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_include shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
