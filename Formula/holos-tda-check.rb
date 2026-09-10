class HolosTdaCheck < Formula
  desc "Independent checker for Holos proof and coordinate artifacts"
  homepage "https://github.com/t0rsion/holos"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.8.0/holos-tda-check-aarch64-apple-darwin.tar.xz"
      sha256 "946126cc7ff21cd152474bf5bd2a952405637c6c8cba358af5939719d055a6f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.8.0/holos-tda-check-x86_64-apple-darwin.tar.xz"
      sha256 "133da96d8f80db7f6663cab95b822ab681f14395559222813f6901a4715f707c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.8.0/holos-tda-check-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9fbe10fdf628f07cc4dce3bc15662fa146e3531fdecace0b1020fe8e2b2d47fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.8.0/holos-tda-check-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cdcc3a2de122b8a8767b2e269e5b6dcdfb62116eeb2d75d33503a7c5fc17b075"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "holos-check"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "holos-check"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "holos-check"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "holos-check"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
